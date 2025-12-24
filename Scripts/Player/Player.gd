class_name Player extends CharacterBody2D

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
@export_color_no_alpha var character_color
@export_color_no_alpha var aura_color

@onready var speed = base_speed
@onready var boost_stock = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boost_audio: AudioStreamPlayer2D = $BoostAudio
@onready var mega_boost_audio: AudioStreamPlayer2D = $MegaBoostAudio
@onready var footstep_audio: AudioStreamPlayer2D = $FootstepAudio
@onready var slide_audio: AudioStreamPlayer2D = $SlideAudio
@onready var sprite: Sprite2D = $Sprite2D
@onready var aura: AnimatedSprite2D = $AuraAnimation
@onready var obstacle_detector: Area2D = $ObstacleDetector

var xp : int = 0
var on_rail : bool = false
var obstacle_encountered : bool = false

func _ready() -> void:
	if character_color:
		sprite.modulate = character_color
	else : 
		sprite.modulate = Settings.character_color
	if aura_color:
		aura.modulate = aura_color
	else : 
		aura.modulate = Settings.aura_color

func _process(delta: float) -> void:
	aura.modulate.a = min(inverse_lerp(max_speed, max_speed*mega_boost_factor, speed),0.5)

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

func _play_footstep_audio():
	footstep_audio.play()
