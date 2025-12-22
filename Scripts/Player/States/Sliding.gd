extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("RESET")
	player.sprite.frame = 1

func physics_update(delta: float) -> void:
	player.boost_stock = min(player.boost_stock + player.boost_generation * delta, 100.0)
	player.speed = clamp(player.speed + player.rail_acceleration * delta, player.base_speed, player.max_speed)
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	EventBus.boost_value_changed.emit(player.boost_stock)
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("ui_up"):
		finished.emit(JUMPING)
