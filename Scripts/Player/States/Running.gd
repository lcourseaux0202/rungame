extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("RunAnimation")
	player.set_collision_mask_value(2, true)

func physics_update(delta: float) -> void:
	player.animation_player.speed_scale = max(inverse_lerp(player.base_speed, player.max_speed * 2, player.speed) * 3, player.min_animation_speed_scale)
	if(player.speed > player.max_speed):
		player.speed = player.speed - player.deceleration * delta
	else:
		player.speed = clamp(player.speed + player.acceleration * delta, player.base_speed, player.max_speed)
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.auto and player.ray_cast_2d.is_colliding():
		finished.emit(JUMPING)
	elif player.auto and player.boost_stock >= 100:
		finished.emit(BOOSTING)
	elif player.obstacle_encountered:
		finished.emit(RECOVERING)
	elif player.on_rail:
		finished.emit(SLIDING)
	elif not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed(player.input_up):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed(player.input_right) and player.boost_stock >= player.stock_needed_for_boost:
		finished.emit(BOOSTING)
