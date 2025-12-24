class_name CameraMusic extends Camera2D

@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic
@onready var zooming_on_player : bool = false
@onready var base_zoom : Vector2 = self.zoom
@onready var base_offset : Vector2 = self.offset

@export var zoom_factor : Vector2 = Vector2(0.95, 0.95) 
@export var shake_intensity : float = 2.0

func _ready() -> void:
	EventBus.zoom_on_player.connect(_zoom_on_player)
	
func _process(_delta: float) -> void:
	if zooming_on_player:
		offset = base_offset + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		offset = lerp(offset, base_offset, 0.01)


func _zoom_on_player(player : Player) -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if player != null:
		zooming_on_player = true
		tween.tween_property(self, "zoom", zoom_factor, 0.5)
	else:
		zooming_on_player = false
		tween.tween_property(self, "zoom", base_zoom, 0.5)
		
func pitch_audio_with_level_completion(completion : float = 0.5) -> void:
	var pitch = (completion - 0.5) * 1.5
	background_music.pitch_scale = pitch
