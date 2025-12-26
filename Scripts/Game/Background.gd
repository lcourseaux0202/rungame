class_name Background extends Parallax2D

func _ready() -> void:
	modulate = Settings.world_color.darkened(0.9)
