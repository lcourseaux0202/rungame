extends Node2D

@export var sections : Array[PackedScene]
@export_range(1,10,1) var sectionNumber : int

@onready var camera: Camera2D = $Camera
@onready var player: Player = $Player

var next_section_marker : Marker2D = null

func _ready() -> void:
	for i in range(sectionNumber):
		place_random_section()

func place_random_section() -> void:
	var new_section : Section = sections.pick_random().instantiate()
	call_deferred("add_child", new_section) 
	
	if next_section_marker:
		new_section.global_position = next_section_marker.global_position
	
	next_section_marker = new_section.next_section_position_marker

func _process(delta: float) -> void:
	camera.position = player.position
