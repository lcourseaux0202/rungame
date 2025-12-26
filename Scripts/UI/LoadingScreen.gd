class_name LoadingScreen extends Control

@onready var progress_bar: ProgressBar = $HBoxContainer/ProgressBar

func _ready() -> void:
	EventBus.element_loaded.connect(_on_element_loaded)
	progress_bar.value = 0
	visible = true
	
func set_quantity_to_load(quantity : int):
	progress_bar.value = 0
	progress_bar.max_value = quantity
	
func _on_element_loaded() -> void:
	progress_bar.value += 1
	if progress_bar.value == progress_bar.max_value:
		visible = false
