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
@export_range(1.0,3.0) var boost_factor := 1.15
@export_range(1.0,3.0) var mega_boost_factor := 1.6
@export var boost_generation := 100.0
@export var boost_per_xp := 1.0
@export var stock_needed_for_boost := 30.0
@export var max_boost := 100
@export var boost_passive_generation := 0
@export_range(1,10) var jump_number := 2
@export_range(0.0,10.0) var min_animation_speed_scale := 0.6
@export var auto := false


### Utils ###
var can_run := false
var skin : SkinData = null
var speed = base_speed
var boost_stock = 0
var xp : int = 0
var xp_gain = Settings.xp_gain_per_orb
var on_rail : bool = false
var obstacle_encountered : bool = false

### Components ###
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boost_audio: AudioStreamPlayer2D = $Audios/BoostAudio
@onready var mega_boost_audio: AudioStreamPlayer2D = $Audios/MegaBoostAudio
@onready var footstep_audio: AudioStreamPlayer2D = $Audios/FootstepAudio
@onready var slide_audio: AudioStreamPlayer2D = $Audios/SlideAudio
@onready var sprite: Sprite2D = $Sprite2D
@onready var aura: AnimatedSprite2D = $AuraAnimation
@onready var obstacle_detector: Area2D = $ObstacleDetector
@onready var speed_label: Label = $HBoxContainer/SpeedLabel
@onready var boost_bar: BoostBar = $HBoxContainer/BoostBar
@onready var ray_cast_2d: RayCast2D = $AI/RayCast2D
@onready var orb_magnet: OrbMagnet = $OrbMagnet

### Multiplayer ###
var input_up: String
var input_right: String
var input_down: String
@export var player_id := 0

func _ready() -> void:
	add_to_group("Players")
	orb_magnet.orb_detected.connect(_handle_orb_gathering)
	
	input_up = "JumpP%d" % (player_id + 1)
	input_right = "BoostP%d" % (player_id + 1)
	input_down = "FastFallP%d" % (player_id + 1)
	
	global_position.x -= player_id * 10
	
	if Settings.selected_skins[player_id] != null :
		skin = Settings.selected_skins[player_id]
	else :
		skin = load(Settings.default_skin)
		
	sprite.modulate = skin.character_color
	aura.modulate = skin.aura_color
	if skin.additional_effect:
		sprite.material = skin.additional_effect
	
	boost_bar.set_bars_colors(skin)
	
	var layer_cible = (player_id - 1) + 2
	boost_bar.visibility_layer = (1 << (layer_cible - 1))
	speed_label.visibility_layer = (1 << (layer_cible - 1))
	
func start_running() -> void :
	can_run = true
	

func _process(_delta: float) -> void:
	aura.modulate.a = min(inverse_lerp(max_speed, max_speed*mega_boost_factor, speed),0.5)
	speed_label.text = str(int(speed / 10)) + " Km/h"
	speed = min(speed, max_speed*mega_boost_factor)

func update_boost_bar(boost_value : float):
	boost_bar.update_value(boost_value, stock_needed_for_boost, max_boost)

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
		
func _handle_orb_gathering(orb: XpOrb) -> void:
	orb.make_disappear(self)
	xp += xp_gain

func _play_footstep_audio():
	footstep_audio.play()
	
func update_orb_magnet_radius(modifier : float):
	orb_magnet.update_collision_radius(modifier)
