class_name OrbMagnet extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal orb_detected(orb : XpOrb)

func update_collision_radius(radius_modifier : float) -> void :
	var circle_shape : CircleShape2D = collision_shape.shape as CircleShape2D
	circle_shape.radius += radius_modifier


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Orbs"):
		orb_detected.emit(area)
