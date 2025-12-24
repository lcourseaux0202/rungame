extends Node2D

@export var sections : Array[PackedScene]
@export_range(1,10,1) var sectionNumber : int

@onready var camera: CameraMusic = $Camera
@onready var player: Player = $Player
@onready var main_ui: MainUI = $Camera/CanvasLayer/MainUi
@onready var upgrade_select_menu: UpgradeSelectMenu = $Camera/CanvasLayer/UpgradeSelectMenu
@onready var sections_container: Node2D = $SectionsContainer
@onready var sky: Sprite2D = $Parallax2D/Sky
@onready var settings_menu: SettingsMenu = $Camera/CanvasLayer/SettingsMenu


var next_section_marker : Marker2D = null
var sections_queue : Array[Section]

var restarting : bool = false

func _ready() -> void:
	sky.modulate = Settings.world_color.darkened(0.9)
	upgrade_select_menu.hide()
	_place_selected_section(0)
	for i in range(sectionNumber):
		_place_random_section()

func _process(delta: float) -> void:
	camera.global_position.x = player.global_position.x 
	#camera.pitch_audio_with_level_completion()
	main_ui.update_progression_value(player.global_position.x)
	if player.global_position.x >= Settings.level_length and not restarting:
		restarting = true
		_trigger_restart_sequence()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		settings_menu.open_menu(1)
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
	await upgrade_select_menu.reveal()
	restart()

func restart() -> void:
	player.global_position.x = 0
	player.speed = player.base_speed
	sections_queue.clear()
	next_section_marker = null
	for sections in sections_container.get_children():
		sections.queue_free()
	
	_place_selected_section(0)
	for i in range(sectionNumber):
		_place_random_section()
		
	camera.global_position.x = player.global_position.x
	camera.reset_smoothing()
	
	restarting = false
