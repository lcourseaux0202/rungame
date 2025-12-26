class_name Section extends Node2D

@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var next_section_position_marker: Marker2D = $NextSectionPosition
@onready var next_section_area: Area2D = $NextSectionArea

signal create_new_section()

var section_triggered := false 

func _ready() -> void:
	if Settings.world_color:
		tile_map.modulate = Settings.world_color
	next_section_area.body_entered.connect(_on_body_entered_next_section_area)
	
func _on_body_entered_next_section_area(body):
	if body is Player and not section_triggered:
		section_triggered = true
		call_deferred("_emit_create_section")

func _emit_create_section():
	create_new_section.emit()
	next_section_area.queue_free()
