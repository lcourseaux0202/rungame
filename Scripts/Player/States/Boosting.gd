extends PlayerState


func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("RunAnimation")
	
	if player.boost_stock >= 100.0:
		player.mega_boost_audio.play()
		player.speed = player.max_speed * player.mega_boost_factor
		player.boost_stock -= 100
	else:
		player.boost_audio.play()
		player.speed = max(player.speed, player.max_speed) * player.boost_factor
		player.boost_stock -= player.stock_needed_for_boost
	
	player.update_boost_bar(player.boost_stock)
	EventBus.zoom_on_player.emit(player)

func physics_update(delta: float) -> void:
	player.boost_stock = clamp(player.boost_stock + player.boost_passive_generation * delta,0, player.max_boost)
	player.update_boost_bar(player.boost_stock)
	player.animation_player.speed_scale = max(inverse_lerp(player.base_speed, player.max_speed * player.mega_boost_factor, player.speed) * 3, player.min_animation_speed_scale)
	player.speed = player.speed - player.boost_deceleration * delta
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.auto and player.ray_cast_2d.is_colliding():
		finished.emit(JUMPING)
	elif player.speed <= player.max_speed:
		finished.emit(RUNNING)
	if player.obstacle_encountered:
		finished.emit(RECOVERING)
	if player.on_rail:
		finished.emit(SLIDING)
	elif not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed(player.input_up):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed(player.input_right) and player.boost_stock >= player.stock_needed_for_boost:
		finished.emit(BOOSTING)
		
func exit() -> void:
	EventBus.zoom_on_player.emit(null)
