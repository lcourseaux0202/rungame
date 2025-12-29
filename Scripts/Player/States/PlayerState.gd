class_name PlayerState extends State

const WAIT = "Wait"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const SLIDING = "Sliding"
const RECOVERING = "Recovering"
const BOOSTING = "Boosting"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
