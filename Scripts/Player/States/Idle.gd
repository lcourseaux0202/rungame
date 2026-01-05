extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("RESET")

func physics_update(_delta: float) -> void:
	if player.can_run:
		finished.emit(RUNNING)
