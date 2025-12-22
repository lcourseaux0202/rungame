extends CharacterBody2D

const JUMP_VELOCITY = -300.0
const MAX_SPEED = 25000
const BASE_SPEED = 10000
const MAX_BOOST = 100
const FAST_FALL = 500

var speed = BASE_SPEED
var started : bool = false
var double_jump : bool = true
var on_rail : bool = false
var boost = 0
var boosting = false

func _physics_process(delta: float) -> void:
	if started:
		if not is_on_floor() and not on_rail:
			if Input.is_action_just_pressed("fast_fall"):
				velocity.y += FAST_FALL
			velocity += get_gravity() * delta
			$AnimationPlayer.stop()
			
		
		if is_on_floor() or on_rail:
			double_jump = true
			
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() or on_rail:
				$JumpParticles.emitting = true
				velocity.y = JUMP_VELOCITY
			elif (not is_on_floor() and not on_rail) and double_jump :
				$JumpParticles.emitting = true
				velocity.y = JUMP_VELOCITY
				double_jump = false
			
		$AnimationPlayer.speed_scale = min(speed / 1500, 15)
		
		if on_rail :
			$AnimationPlayer.stop()
			$Sprite2D.frame = 1
			$SlideParticles.emitting = true
			speed = max(speed - 80, BASE_SPEED * 2)
			boost = min(boost + 1, MAX_BOOST) 
			boosting = false
		else :
			$AnimationPlayer.play("run_animation")
			$SlideParticles.emitting = false

			if Input.is_action_pressed("boost") and boost > 0 and not on_rail:
				speed = min(speed + 500, MAX_SPEED * 3)
				boost = max(boost - 1, 0)
				boosting = true
			else :
				speed = min(speed + 100, MAX_SPEED)
				boosting = false
			
		velocity.x = speed * delta
		
		
		$BoostLabel.text = str(boost) + "%"
		
		move_and_slide()
		
func _process(delta: float) -> void:
	$BoostLabel.set("theme_override_colors/font_color", Color("yellow"))

func start():
	started = true
	$AnimationPlayer.play("run_animation")

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is TileMapLayer :
		speed = BASE_SPEED
		set_collision_mask_value(1, false)

func _on_death_zone_body_exited(body: Node2D) -> void:
	if body is TileMapLayer :
		set_collision_mask_value(1, true)
	

func _on_rail_zone_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Rails":
		on_rail = true
		velocity.y = 0
		position.y = area.position.y - 13
	if area.get_parent().name == "BoostPanels":
		speed = MAX_SPEED
		velocity.y = JUMP_VELOCITY * 2


func _on_rail_zone_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "Rails":
		on_rail = false
