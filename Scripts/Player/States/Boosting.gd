extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("RunAnimation")
	player.speed = player.max_speed * player.boost_factor
	player.boost_stock -= player.stock_needed_for_boost
	
	EventBus.boost_value_changed.emit(player.boost_stock)

func physics_update(delta: float) -> void:
	player.animation_player.speed_scale = max(inverse_lerp(player.base_speed, player.max_speed * 2, player.speed) * 3, player.min_animation_speed_scale)
	player.speed = player.speed - player.deceleration * delta
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.speed <= player.max_speed:
		finished.emit(RUNNING)
	if player.obstacle_encountered:
		finished.emit(RECOVERING)
	if player.on_rail:
		finished.emit(SLIDING)
	elif not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("ui_up"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("ui_right") and player.boost_stock >= player.stock_needed_for_boost:
		finished.emit(BOOSTING)
