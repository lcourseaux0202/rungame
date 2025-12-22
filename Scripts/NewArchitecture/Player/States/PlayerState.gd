class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const DOUBLE_JUMPING = "DoubleJumping"
const FALLING = "Falling"
const FALLING_NO_JUMP = "FallingNoJump"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
