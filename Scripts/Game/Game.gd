extends Node2D

@export var sections : Array[PackedScene]
@export_range(1,10,1) var sectionNumber : int

@onready var camera: CameraMusic = $Camera
@onready var main_ui: MainUI = $Camera/CanvasLayer/MainUi
@onready var upgrade_select_menu: UpgradeSelectMenu = $Camera/CanvasLayer/UpgradeSelectMenu
@onready var sections_container: Node2D = $SectionsContainer
@onready var sky: Sprite2D = $Parallax2D/Sky
@onready var loading_screen: LoadingScreen = $Camera/CanvasLayer/LoadingScreen
@onready var settings_menu: SettingsMenu = $Camera/CanvasLayer/SettingsMenu

@onready var players_container: Node2D = $PlayersContainer


var next_section_marker : Marker2D = null
var sections_queue : Array[Section]

var restarting : bool = false

func _ready() -> void:
	loading_screen.set_quantity_to_load(sections.size())
	for schema in sections:
		var temp_instance = schema.instantiate()
		add_child(temp_instance)
		await get_tree().process_frame 
		temp_instance.queue_free()
		loading_screen.element_loaded()
	sky.modulate = Settings.world_color.darkened(0.9)
	upgrade_select_menu.hide()
	_place_selected_section(0)
	for i in range(sectionNumber):
		_place_random_section()

func _process(delta: float) -> void:
	var best_player = _get_best_player()
	camera.global_position.x = players_container.get_child(0).global_position.x 
	main_ui.update_progression_value(best_player.global_position.x)
	if best_player.global_position.x >= Settings.level_length and not restarting:
		restarting = true
		_trigger_restart_sequence()
		
	if players_container.get_child_count() > 1:
		_boost_worst_player(delta)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		settings_menu.open_menu()
		get_tree().paused = true

func _place_selected_section(index : int) -> void:
	var scene_resource = sections[index]
	var new_section : Section = scene_resource.instantiate()
	_place_section(new_section)
	

func _place_random_section() -> void:
	var new_section : Section = sections.pick_random().instantiate()
	_place_section(new_section)
	
func _place_section(new_section : Section) -> void:
	if next_section_marker:
		new_section.global_position = next_section_marker.global_position
	else:
		new_section.global_position = Vector2.ZERO
	
	sections_container.add_child(new_section)
	
	next_section_marker = new_section.next_section_position_marker
	new_section.create_new_section.connect(_place_random_section)
	
	sections_queue.append(new_section)
	if sections_queue.size() > Settings.max_sections:
		sections_queue[0].queue_free()
		sections_queue.pop_front()
		
func _trigger_restart_sequence() -> void :
	upgrade_select_menu.set_card_receivers(_get_players_ordered_by_position())
	await upgrade_select_menu.reveal(upgrade_select_menu.MODE.MULTIPLAYER)
	restart()

func restart() -> void:
	var position_buffer = 0
	for player : Player in players_container.get_children():
		player.global_position.x = 50 * position_buffer
		position_buffer += 1
		player.speed = player.base_speed
	sections_queue.clear()
	next_section_marker = null
	for sections in sections_container.get_children():
		sections.queue_free()
	
	_place_selected_section(0)
	for i in range(sectionNumber):
		_place_random_section()
		
	camera.global_position.x = _get_best_player().global_position.x
	camera.reset_smoothing()
	
	restarting = false

func _get_best_player() -> Player :
	var best_player : Player = players_container.get_child(0)
	for player : Player in players_container.get_children():
		if player.global_position.x > best_player.global_position.x :
			best_player = player
	return best_player
	
func _boost_worst_player(delta : float) -> void :
	var worst_player : Player = players_container.get_child(0)
	for player : Player in players_container.get_children():
		if player.global_position.x < worst_player.global_position.x :
			worst_player = player
	worst_player.boost_stock = min(worst_player.boost_stock + (worst_player.boost_generation * delta / 2), 100.0)
	if not worst_player.auto:
		EventBus.boost_value_changed.emit(worst_player.boost_stock, worst_player.boost_stock >= worst_player.stock_needed_for_boost)
	
func _get_players_ordered_by_position() -> Array[Player]:
	var list : Array[Player] = []
	for player : Player in players_container.get_children():
		list.append(player)
	list.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)
	return list
