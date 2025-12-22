extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.play("RunAnimation")
	player.speed = player.base_speed
	player.set_collision_mask_value(2, false)

func physics_update(delta: float) -> void:
	player.velocity.x = player.speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if not player.obstacle_encountered and player.is_on_floor():
		finished.emit(RUNNING)
	elif Input.is_action_just_pressed("ui_up"):
		finished.emit(JUMPING)
