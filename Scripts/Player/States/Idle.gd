extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("RESET")

func physics_update(_delta: float) -> void:
	if player.can_run:
		finished.emit(RUNNING)
