extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("RunAnimation")

func physics_update(delta: float) -> void:
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("ui_up"):
		finished.emit(JUMPING)
