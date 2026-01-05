extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("RunAnimation")
	player.speed = min(player.base_speed, player.max_speed)
	player.set_collision_mask_value(2, false)

func physics_update(delta: float) -> void:
	player.boost_stock = clamp(player.boost_stock + player.boost_passive_generation * delta,0, player.max_boost)
	player.update_boost_bar(player.boost_stock)
	player.animation_player.speed_scale = max(inverse_lerp(player.base_speed, player.max_speed * 2, player.speed) * 3, player.min_animation_speed_scale)
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if not player.obstacle_encountered:
		finished.emit(RUNNING)
	elif Input.is_action_just_pressed(player.input_up):
		finished.emit(JUMPING)
		
