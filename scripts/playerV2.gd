extends CharacterBody2D

const JUMP_VELOCITY = -300

@export var baseSpeed = 10000
@export var maxSpeed = 25000
@export var maxBoost = 100
@export var fastFallSpeed = 500
@export var maxJumps = 2

var speed = 0
var boost = 0
var hasDoubleJump = true
var isBoosting = false
var isSliding = false
var gameStarted = false
var nbJumps = maxJumps

var boostHold
var boostRelease
var boostTap
var jumpHold
var jumpRelease
var jumpTap
var fastFallHold
var fastFallRelease
var fastFallTap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	boostHold = Input.is_action_pressed("boost")
	boostRelease = Input.is_action_just_released("boost")
	boostTap = Input.is_action_just_pressed("boost")
	jumpHold = Input.is_action_pressed("jump")
	jumpRelease = Input.is_action_just_released("jump")
	jumpTap = Input.is_action_just_pressed("jump")
	fastFallHold = Input.is_action_pressed("fast_fall")
	fastFallRelease = Input.is_action_just_released("fast_fall")
	fastFallTap = Input.is_action_just_pressed("fast_fall")
	
	if is_on_floor() :
		nbJumps = 2
		speed += 1
		
	if !is_on_floor() and jumpTap and nbJumps > 0:
		nbJumps -= 1
	
	if isSliding :
		boost += 1
		speed -= 1
		
	if boostHold :
		isBoosting = true
	
	
	velocity.x = speed
	
func start():
	gameStarted = true


func _on_rail_zone_area_entered(area: Area2D) -> void:
	isSliding = true


func _on_rail_zone_area_exited(area: Area2D) -> void:
	isSliding = false


func _on_death_zone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_death_zone_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
