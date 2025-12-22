extends PlayerState

var n_jump : int

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = -player.jump_impulse
	player.animation_player.play("RESET")
	if data.has("n_jump"):
		n_jump = data["n_jump"]
	else : n_jump = 1

func physics_update(delta: float) -> void:
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if player.velocity.y >= 0:
		finished.emit(FALLING, {"n_jump" : n_jump})
	elif Input.is_action_just_pressed("ui_up") and n_jump < player.jump_number:
		finished.emit(JUMPING, {"n_jump" : n_jump + 1})
