extends Camera2D

const MAX_ZOOM = Vector2(1.6,1.6)
const INITIAL_ZOOM = Vector2(1.5,1.5)

var random_strength = 1.0
var shake_fade = 0.1
var shake_strength = 0.0

var player : CharacterBody2D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -120
	player = get_parent().get_node("Player")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = $"../Player".position.x + 300
	if player.on_rail or player.boosting :
		var new_zoom = Vector2(zoom.x + 0.002, zoom.y + 0.002)
		if abs(new_zoom) < abs(MAX_ZOOM):
			zoom = new_zoom
		if offset.x > -400:
			offset.x -= 1
		if player.boosting:
			apply_strength()
	else :
		var new_zoom = Vector2(zoom.x - 0.005, zoom.y - 0.005)
		if abs(new_zoom) > abs(INITIAL_ZOOM):
			zoom = new_zoom
		if offset.x < 0:
			offset.x += 3
			shake_strength = 0
			
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()

func apply_strength():
	shake_strength = random_strength
	
func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
