class_name PlayerCamera extends Camera2D

@onready var zooming_on_player : bool = false
@onready var base_zoom : Vector2 = self.zoom
@onready var base_offset : Vector2 = self.offset

@export var zoom_factor : Vector2 = Vector2(0.95, 0.95) 
@export var shake_intensity : float = 2.0

var player : Player = null
@export var follow_threshold: float = -150.0 
@export var upward_speed: float = 5.0        
@export var downward_speed: float = 12.0
@export var horizontal_speed: float = 8.0

func _ready() -> void:
	if Settings.is_gamemode_solo() :
		follow_threshold *= 2
	EventBus.zoom_on_player.connect(_zoom_on_player)

func _physics_process(delta: float) -> void:
	if not player:
		return
	global_position.x = lerp(global_position.x, player.global_position.x, horizontal_speed * delta)
	var target_y = 0.0
	if player.global_position.y < follow_threshold:
		target_y = player.global_position.y - follow_threshold
	else:
		target_y = 0.0
	var current_speed: float
	if target_y > global_position.y:
		current_speed = downward_speed
	else:
		current_speed = upward_speed
	global_position.y = lerp(global_position.y, target_y, current_speed * delta)



func _process(_delta: float) -> void:
	if zooming_on_player:
		offset = base_offset + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		offset = lerp(offset, base_offset, 0.01)


func _zoom_on_player(target : Player) -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if target != null:
		zooming_on_player = true
		tween.tween_property(self, "zoom", zoom_factor, 0.5)
	else:
		zooming_on_player = false
		tween.tween_property(self, "zoom", base_zoom, 0.5)
