extends Control
class_name MainUI

@onready var boost_bar: TextureProgressBar = $BoostBar
@onready var level_progression: ProgressBar = $HBoxContainer/LevelProgression


var boost_tween: Tween

func _ready() -> void:
	level_progression.value = 0
	level_progression.max_value = Settings.level_length
	EventBus.boost_value_changed.connect(_update_boost_bar)

func _update_boost_bar(boost_value : float, can_boost : bool):
	if boost_value < boost_bar.value:
		if boost_tween:
			boost_tween.kill()
		
		boost_tween = create_tween()
		boost_tween.tween_property(boost_bar, "value", boost_value, 0.5)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		
	else:
		if boost_tween and boost_tween.is_running():
			boost_tween.kill()
		boost_bar.value = boost_value
		

	var mat = boost_bar.material as ShaderMaterial
	mat.set_shader_parameter("can_boost", can_boost)
	mat.set_shader_parameter("is_full", (boost_value >= boost_bar.max_value))

func update_progression_value(new_value : int):
	level_progression.value = new_value
