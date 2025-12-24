class_name XpOrb extends Area2D

const XP_GAIN = 10
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var collect_audio: AudioStreamPlayer2D = $CollectAudio

func _ready() -> void:
	modulate = Settings.aura_color

func _on_body_entered(body: Node2D) -> void:
	var player : Player = body as Player
	player.xp += XP_GAIN
	player.boost_stock = clamp(player.boost_stock + player.boost_per_xp, 0, 100)
	
	EventBus.boost_value_changed.emit(player.boost_stock, player.boost_stock >= player.stock_needed_for_boost)
	
	collect_audio.play()
	
	var tween : Tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.2)
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y - 20), 0.2)
