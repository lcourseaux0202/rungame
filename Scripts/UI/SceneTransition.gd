extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@export var switch_duration := 1.0
@export var current_scene : PackedScene
	
func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.modulate.a = 0.0
	
func go_to_scene(scene : PackedScene) -> void :
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween : Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, 'modulate:a', 1, switch_duration / 2.0)
	await tween.finished
	
	get_tree().change_scene_to_packed(scene)
	get_tree().paused = false
	current_scene = scene
	
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, 'modulate:a', 0, switch_duration / 2.0)
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
