extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.slide_audio.play()
	player.animation_player.play("AirAnimation")

func physics_update(delta: float) -> void:
	player.boost_stock = min(player.boost_stock + player.boost_generation * delta, 100.0)
	if(player.speed > player.max_speed):
		player.speed = player.speed - player.rail_deceleration * delta
	else :
		player.speed = clamp(player.speed - player.rail_deceleration * delta, player.base_speed, player.max_speed)
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	EventBus.boost_value_changed.emit(player.boost_stock, (player.boost_stock >= player.stock_needed_for_boost))
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("ui_up"):
		finished.emit(JUMPING)

func exit() -> void:
	player.slide_audio.stop()
