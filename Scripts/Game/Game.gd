extends Node2D

@export var sections : Array[PackedScene]
@export_range(1,10,1) var sectionNumber : int

@onready var camera: Camera2D = $Camera
@onready var player: Player = $Player
@onready var main_ui: MainUI = $Camera/CanvasLayer/MainUi


var next_section_marker : Marker2D = null
var sections_queue : Array[Section]

func _ready() -> void:
	_place_selected_section(0)
	for i in range(sectionNumber):
		_place_random_section()

func _process(delta: float) -> void:
	camera.global_position.x = player.global_position.x 

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
	
	add_child(new_section)
	
	next_section_marker = new_section.next_section_position_marker
	new_section.create_new_section.connect(_place_random_section)
	
	sections_queue.append(new_section)
	if sections_queue.size() > Settings.MAX_SECTIONS:
		sections_queue[0].queue_free()
		sections_queue.pop_front()
