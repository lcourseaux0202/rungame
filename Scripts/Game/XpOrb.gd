class_name XpOrb extends Area2D

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var collect_audio: AudioStreamPlayer2D = $CollectAudio
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	modulate = Color.AQUA

func make_disappear(player: Player) -> void:
	duplicate()
	set_deferred("monitoring", false)
	collision.set_deferred("disabled", true)
	
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	var up_pos = global_position + Vector2(0, -50)
	tween.tween_property(self, "global_position", up_pos, 0.2)
	
	var start_pos = up_pos
	tween.tween_method(
		func(lerp_val): global_position = start_pos.lerp(player.sprite.global_position, lerp_val),
		0.0, 1.0, 0.5
	)
	
	await tween.finished
	
	player.boost_stock = min(player.boost_stock + player.boost_per_xp, 100.0)
	player.update_boost_bar(player.boost_stock)
	
	if collect_audio:
		collect_audio.play()
		visible = false
		await collect_audio.finished
	
	queue_free()
