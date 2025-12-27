class_name Level extends Node2D

@export var sections : Array[PackedScene]
@export_range(1,50,1) var sectionNumber : int = 50

@onready var sections_container: Node2D = $SectionsContainer
@onready var finish_line: Node2D = $FinishLine

var next_section_marker : Marker2D = null
var sections_queue : Array[Section]


func _ready() -> void:
	finish_line.global_position = Vector2(Settings.level_length, 0)
	for schema in sections:
		var temp_instance = schema.instantiate()
		add_child(temp_instance)
		await get_tree().process_frame 
		temp_instance.queue_free()
		EventBus.element_loaded.emit()
	_place_selected_section(0)
	for i in range(sectionNumber):
		_place_random_section()

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

func restart() -> void:
	sections_queue.clear()
	next_section_marker = null
	for section in sections_container.get_children():
		section.queue_free()
	_place_selected_section(0)
	for i in range(sectionNumber):
		_place_random_section()
