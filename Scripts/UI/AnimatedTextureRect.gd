@tool
class_name AnimatedTextureRect extends TextureRect
@export var sprites : SpriteFrames 
@export var current_animation = "default"
@export var frame = 0
@export_range(0.0, 100.0,0.01) var speed_scale := 1.0
@export var autoplay := false
@export var playing := false

var refresh_rate = 1.0
var fps = 30.0
var frame_delta = 0

func _ready() -> void:
	fps = sprites.get_animation_speed(current_animation)
	refresh_rate = sprites.get_frame_duration(current_animation, frame)
	if autoplay:
		play()

func _process(delta: float) -> void:
	if sprites == null or not playing:
		return
		
	if not sprites.has_animation(current_animation):
		playing = false
		return

	frame_delta += delta * speed_scale
	
	var time_per_frame = (1.0 / fps) * refresh_rate
	
	if frame_delta >= time_per_frame:
		texture = get_next_frame()
		frame_delta = 0.0

func play(animation_name : String = current_animation) -> void:
	frame = 0
	frame_delta = 0.0
	current_animation = animation_name
	get_animation_data(current_animation)
	playing = true
	
func get_animation_data(animation_name : String = current_animation) -> void:
	fps = sprites.get_animation_speed(animation_name)
	refresh_rate = sprites.get_frame_duration(animation_name, 0)

func get_next_frame():
	frame += 1
	var frame_count = sprites.get_frame_count(current_animation)
	if frame >= frame_count:
		frame = 0
		if not sprites.get_animation_loop(current_animation):
			playing = false
	get_animation_data(current_animation)
	return sprites.get_frame_texture(current_animation, frame)

func resume():
	playing = true
	
func pause():
	playing = false
	
func stop():
	frame = 0
	playing = false
	
func animate_transparency(duration : float):
	modulate.a = 1.0
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration/2.0)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration/2.0)
	modulate.a = 0.0
