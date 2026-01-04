extends Node


const player_camera_scene = preload("res://Scenes/Game/PlayerCamera.tscn")

@onready var screen_container: GridContainer = $CenterContainer/GridContainer
@onready var card_menu: CardMenu = $CardMenu
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var loading_screen: LoadingScreen = $LoadingScreen
@onready var solo_game_ui: SoloGameUI = $SoloGameUi

var game_to_load : String = "res://Scenes/Game/Level.tscn"
var background_to_load : String = "res://Scenes/Game/Background.tscn"
var first_subviewport : SubViewport = null
var game_node : Level = null
var players : Array[Player]
var player_cameras : Array[PlayerCamera]

@export var difficulty_curve : Curve
var restarting := true
var current_level_length := 0
var current_level := 0
var progression := 0.0

const LEVEL_TIME_DURATION = 99
const MAX_BOOST_STOCK_HELP = 90
const BOOST_HELP_GENERATION = 0

func _ready() -> void:
	_add_new_player_viewport(null, 0)
	_update_viewport_size()
	new_multiplayer_game(Settings.number_of_players)

func _process(delta: float) -> void:
	var best_player = _get_best_player()
	if best_player.global_position.x >= current_level_length and not restarting:
		restarting = true
		_trigger_restart_sequence()
	if players.size() > 1 :
		_boost_worst_player(delta)

func new_multiplayer_game(number_of_players : int = 1):
	for i in range(number_of_players - 1):
		var new_player : Player = load("res://Scenes/Player/Player.tscn").instantiate()
		new_player.player_id = i + 1
		game_node.add_child(new_player)
		_add_new_player_viewport(new_player, i)
		_update_viewport_size()
		
		players.append(new_player)

func _add_new_player_viewport(new_player_node : Player, index : int) -> void:
	var new_subviewport_container : SubViewportContainer = SubViewportContainer.new()
	var new_subviewport : SubViewport = SubViewport.new()
	new_subviewport_container.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	new_subviewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	new_subviewport.disable_3d = true
	new_subviewport.audio_listener_enable_2d = true
	
	var new_camera2d : PlayerCamera = player_camera_scene.instantiate()
	
	screen_container.add_child(new_subviewport_container)
	new_subviewport_container.add_child(new_subviewport)
	new_subviewport.add_child(new_camera2d)
	player_cameras.append(new_camera2d)
	
	var layer_commun = 1 << 0
	var layer_prive = 1 << (index + 2 - 1)
	new_subviewport.canvas_cull_mask = layer_commun | layer_prive
	
	if first_subviewport:
		var background_node : Parallax2D = load(background_to_load).instantiate()
		new_subviewport.add_child(background_node)
		new_camera2d.player = new_player_node
		new_subviewport.world_2d = first_subviewport.world_2d
	else :
		var background_node : Parallax2D = load(background_to_load).instantiate()
		new_subviewport.add_child(background_node)
		game_node = load(game_to_load).instantiate()
		new_subviewport.add_child(game_node)
		first_subviewport = new_subviewport
		var first_player = game_node.get_tree().get_nodes_in_group("Players")[0]
		new_camera2d.player = first_player
		players.append(first_player)
		loading_screen.set_quantity_to_load(game_node.sections.size())
		game_node.level_loaded.connect(_start_game)

func _update_viewport_size() -> void :
	screen_container.columns = ceil(screen_container.get_child_count() / 2.0)
	for viewport_node in screen_container.get_children():
		var subviewport_node : SubViewport = viewport_node.get_child(0)
		var game_size : Vector2 = get_viewport().get_visible_rect().size
		subviewport_node.size.x = game_size.x / screen_container.columns
		subviewport_node.size.y = game_size.y / ceil(float(screen_container.get_child_count()) / float(screen_container.columns))

func _start_game():
	_set_next_level_length()
	_update_cameras_limit()
	game_node.place_finish_line(current_level_length)
	for player in players:
		player.start_running()
	if Settings.is_gamemode_solo():
		solo_game_ui.start_timer(LEVEL_TIME_DURATION, current_level)
		solo_game_ui.game_over.connect(_trigger_gameover_sequence)
	
	restarting = false

func _trigger_restart_sequence() -> void :
	if Settings.is_gamemode_solo():
		solo_game_ui.stop_timer()
		
	card_menu.set_players(_get_players_ordered_by_position())
	await card_menu.reveal_menu()
	
	_set_next_level_length()
	game_node.restart()
	game_node.finish_line.global_position.x = current_level_length
	var position_buffer = 0
	if Settings.is_gamemode_solo():
		solo_game_ui.start_timer(LEVEL_TIME_DURATION, current_level)
	for player : Player in players:
		player.global_position.x = 50 * position_buffer
		position_buffer += 1
		player.speed = player.base_speed
		player.boost_stock = 0
		player.update_boost_bar(0)
	_update_cameras_limit()
	restarting = false
		
func _set_next_level_length() -> void:
	current_level += 1
	progression = min(float(current_level) / Settings.number_of_levels, 1.0) 
	current_level_length = Settings.LAST_LEVEL_LENGTH * difficulty_curve.sample(progression)
	print(current_level_length)
	
func _trigger_gameover_sequence() -> void:
	settings_menu._back_to_menu()

func _get_best_player() -> Player :
	var best_player : Player = players[0]
	for player : Player in players:
		if player.global_position.x > best_player.global_position.x :
			best_player = player
	return best_player

func _boost_worst_player(delta : float) -> void :
	var worst_player : Player = players[0]
	for player : Player in players:
		if player.global_position.x < worst_player.global_position.x :
			worst_player = player
	if worst_player.boost_stock < MAX_BOOST_STOCK_HELP and BOOST_HELP_GENERATION > 0 :
		worst_player.boost_stock = min(worst_player.boost_stock + (worst_player.boost_generation * delta / BOOST_HELP_GENERATION), 100.0)
		worst_player.update_boost_bar(worst_player.boost_stock)

func _get_players_ordered_by_position() -> Array[Player]:
	var list : Array[Player] = []
	for player : Player in players:
		list.append(player)
	list.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)
	return list

func _update_cameras_limit():
	for camera in player_cameras:
		camera.limit_right = current_level_length
		if Settings.is_gamemode_solo():
			camera.global_position.x = 0
		
