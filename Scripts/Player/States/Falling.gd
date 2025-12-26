extends PlayerState

var n_jump : int

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("AirAnimation")
	if data.has("n_jump"):
		n_jump = data["n_jump"]
	else : n_jump = 1

func physics_update(delta: float) -> void:
	if player.speed > player.max_speed:
		player.speed -= player.deceleration * delta
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.obstacle_encountered:
		finished.emit(RECOVERING)
	elif player.on_rail:
		finished.emit(SLIDING)
	elif player.is_on_floor():
		finished.emit(RUNNING)
	elif not player.auto and Input.is_action_just_pressed(player.input_up) and n_jump < player.jump_number:
		finished.emit(JUMPING, {"n_jump" : n_jump + 1})

func handle_input(event: InputEvent) -> void:
	if event.is_action(player.input_down):
		player.velocity.y = player.fast_fall_power
