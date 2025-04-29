extends Node2D

@export var section_scenes : Array[PackedScene]
@export var start_section: PackedScene

var sections : Array[Node2D] = []
var sections_id : Array[int] = []
var current_end_marker : Marker2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_section = start_section.instantiate()
	add_child(first_section)
	current_end_marker = first_section.get_node("Marker2D")
	sections.append(first_section)
	
	for i in range(3):
		add_new_section()

func add_new_section():
	var i = random_index()
	var new_section : Node2D = section_scenes[i].instantiate()
	call_deferred("add_child", new_section)
	
	if current_end_marker:
		new_section.global_position = current_end_marker.global_position
	
	current_end_marker = new_section.get_node("Marker2D")
	
	sections.append(new_section)
	sections_id.append(i)
	
	if sections.size() > 5:
		sections[0].queue_free()
		sections.pop_front()
		
		sections_id.pop_front()

func random_index():
	var i = randi() % section_scenes.size()
	if i in sections_id:
		return random_index()
	else:
		return i
	
