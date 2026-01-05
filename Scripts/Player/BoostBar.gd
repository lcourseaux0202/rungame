class_name BoostBar extends TextureProgressBar

@onready var overcharge_boost_bar: TextureProgressBar = $OverchargeBoostBar
@onready var full_boost_audio: AudioStreamPlayer2D = $FullBoostAudio
var _is_already_full : bool = false
var boost_tween : Tween

func set_bars_colors(skin : SkinData):
	var mat = material.duplicate()
	material = mat
	overcharge_boost_bar.material = mat
	mat = material as ShaderMaterial
	mat.set_shader_parameter("can_boost_color", skin.aura_color)

func update_value(boost_value : float, stock_needed_for_boost : float, max_boost : float):
	overcharge_boost_bar.max_value = max_boost
	if boost_value >= 100:
		overcharge_boost_bar.visible = (max_boost > 100)
		if not _is_already_full:
			full_boost_audio.play()
			scale = Vector2(1.4,1.4)
			var scale_tween : Tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT)
			scale_tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.2)
			_is_already_full = true
	else:
		_is_already_full = false
		
	if boost_value < overcharge_boost_bar.value:
		if boost_tween:
			boost_tween.kill()
		
		boost_tween = create_tween().set_parallel(true)
		boost_tween.tween_property(self, "value", boost_value, 0.5)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		boost_tween.tween_property(overcharge_boost_bar, "value", boost_value, 0.5)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
	else:
		if boost_tween and boost_tween.is_running():
			boost_tween.kill()
		value = boost_value
		overcharge_boost_bar.value = boost_value
		
	var mat = material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("can_boost", (boost_value >= stock_needed_for_boost))
		mat.set_shader_parameter("is_full", (boost_value >= max_value))

func _process(_delta: float) -> void:
	overcharge_boost_bar.visible = (overcharge_boost_bar.value > 100)
