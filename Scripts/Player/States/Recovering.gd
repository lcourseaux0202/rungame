extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("RunAnimation")
	player.speed = player.base_speed
	player.set_collision_mask_value(2, false)
	player.sprite.modulate.a = 0.5

func physics_update(delta: float) -> void:
	player.animation_player.speed_scale = max(inverse_lerp(player.base_speed, player.max_speed * 2, player.speed) * 3, player.min_animation_speed_scale)
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if not player.obstacle_encountered:
		finished.emit(RUNNING)
	elif Input.is_action_just_pressed("ui_up"):
		finished.emit(JUMPING)

func exit() -> void:
	player.sprite.modulate.a = 1
