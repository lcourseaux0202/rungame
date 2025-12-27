class_name Player extends CharacterBody2D

### Stats ###
@export var base_speed := 350.0
@export var max_speed := 900.0
@export var acceleration := 180.0
@export var deceleration := 300.0
@export var boost_deceleration := 200.0
@export var rail_deceleration := 100.0
@export var gravity := 3000.0
@export var jump_impulse := 800.0
@export var fast_fall_power := 1000.0
@export_range(1.0,3.0) var boost_factor := 1.2
@export_range(1.0,3.0) var mega_boost_factor := 1.6
@export var boost_generation := 100.0
@export var boost_per_xp := 1.0
@export var stock_needed_for_boost := 30.0
@export_range(1,10) var jump_number := 2
@export_range(0.0,10.0) var min_animation_speed_scale := 0.6
@export var auto := false


var skin : SkinData = null
var speed = base_speed
var boost_stock = 0
var xp : int = 0
var xp_gain = 10
var boost_tween : Tween 

### Components ###
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boost_audio: AudioStreamPlayer2D = $Audios/BoostAudio
@onready var mega_boost_audio: AudioStreamPlayer2D = $Audios/MegaBoostAudio
@onready var footstep_audio: AudioStreamPlayer2D = $Audios/FootstepAudio
@onready var slide_audio: AudioStreamPlayer2D = $Audios/SlideAudio
@onready var full_boost_audio: AudioStreamPlayer2D = $Audios/FullBoostAudio
@onready var sprite: Sprite2D = $Sprite2D
@onready var aura: AnimatedSprite2D = $AuraAnimation
@onready var obstacle_detector: Area2D = $ObstacleDetector
@onready var speed_label: Label = $HBoxContainer/SpeedLabel
@onready var boost_bar: TextureProgressBar = $HBoxContainer/BoostBar
@onready var ray_cast_2d: RayCast2D = $AI/RayCast2D


### State machine utils ###
var on_rail : bool = false
var obstacle_encountered : bool = false

### Multiplayer ###
var input_up: String
var input_right: String
var input_down: String
@export var player_id := 1

func _ready() -> void:
	var mat = boost_bar.material.duplicate()
	boost_bar.material = mat
	add_to_group("Players")
	input_up = "JumpP%d" % player_id
	input_right = "BoostP%d" % player_id
	input_down = "FastFallP%d" % player_id
	
	global_position.x -= player_id * 10
	
	if Settings.selected_skins[player_id] != null :
		skin = Settings.selected_skins[player_id]
	else :
		skin = load(Settings.default_skin)
		
	sprite.modulate = skin.character_color
	aura.modulate = skin.aura_color
	mat = boost_bar.material as ShaderMaterial
	mat.set_shader_parameter("can_boost_color", skin.aura_color)
	if skin.additional_effect:
		sprite.material = skin.additional_effect
	
	var layer_cible = (player_id - 1) + 2
	boost_bar.visibility_layer = (1 << (layer_cible - 1))
	speed_label.visibility_layer = (1 << (layer_cible - 1))

func _process(delta: float) -> void:
	aura.modulate.a = min(inverse_lerp(max_speed, max_speed*mega_boost_factor, speed),0.5)
	speed_label.text = str(int(speed / 10)) + " Km/h"

func update_boost_bar(boost_value : float):
	if boost_value == boost_bar.max_value and boost_value != boost_bar.value:
		full_boost_audio.play()
	if boost_value < boost_bar.value:
		if boost_tween:
			boost_tween.kill()
		
		boost_tween = create_tween()
		boost_tween.tween_property(boost_bar, "value", boost_value, 0.5)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		
	else:
		if boost_tween and boost_tween.is_running():
			boost_tween.kill()
		boost_bar.value = boost_value
		
	var mat = boost_bar.material as ShaderMaterial
	mat.set_shader_parameter("can_boost", (boost_value >= stock_needed_for_boost))
	mat.set_shader_parameter("is_full", (boost_value >= boost_bar.max_value))

func _on_rail_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Rails"):
		on_rail = true

func _on_rail_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Rails"):
		on_rail = false

func _on_obstacle_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Obstacles"):
		obstacle_encountered = true
		sprite.modulate.a = 0.5

func _on_obstacle_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Obstacles"):
		obstacle_encountered = false
		sprite.modulate.a = 1.0
		
func _on_orb_magnet_area_entered(area: Area2D) -> void:
	if area.is_in_group("Orbs"):
		var orb : XpOrb = area as XpOrb
		orb.make_disappear(self)
		xp += xp_gain

func _play_footstep_audio():
	footstep_audio.play()
