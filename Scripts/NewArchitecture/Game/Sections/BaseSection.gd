class_name Section extends Node2D

@onready var next_section_position_marker: Marker2D = $NextSectionPosition
@onready var next_section_area: Area2D = $NextSectionArea

signal create_new_section()

func _ready() -> void:
	next_section_area.body_entered.connect(_on_body_entered_next_section_area)
	
func _on_body_entered_next_section_area(body):
	if body is Player:
		call_deferred("_emit_create_section")

func _emit_create_section():
	create_new_section.emit()
	next_section_area.queue_free()
