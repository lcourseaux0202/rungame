extends Control
class_name MainUI

@onready var speed_bar: ProgressBar = $Speed

func _ready() -> void:
	GameController.updateRunSpeed.connect(_on_update_run_speed)
	
func _on_update_run_speed(runSpeed : float):
	speed_bar.value = clamp(runSpeed, speed_bar.min_value, speed_bar.max_value)
