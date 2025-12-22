class_name Player extends CharacterBody2D

@export var base_speed := 200.0
@export var max_speed := 1000.0
@export var acceleration := 100.0
@export var deceleration := 50.0
@export var rail_acceleration := -100.0
@export var gravity := 3000.0
@export var jump_impulse := 800.0
@export var fast_fall_power := 1000.0
@export var boost_generation := 50.0
@export var stock_needed_for_boost := 30.0
@export_range(1,10) var jump_number := 2

@onready var speed = base_speed
@onready var boost_stock = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var obstacle_detector: Area2D = $ObstacleDetector

var on_rail : bool = false
var obstacle_encountered : bool = false

func _process(delta: float) -> void:
	pass

func _on_rail_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Rails"):
		on_rail = true

func _on_rail_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Rails"):
		on_rail = false

func _on_obstacle_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Obstacles"):
		obstacle_encountered = true

func _on_obstacle_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Obstacles"):
		obstacle_encountered = false
