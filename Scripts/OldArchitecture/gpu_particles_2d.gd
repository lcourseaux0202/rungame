extends GPUParticles2D

var center = Vector2.ZERO  # Le centre d'attraction

func _process(delta):
	var particles = get_process_material()
	if particles:
		particles.gravity = (center - global_position).normalized() * 50  # Ajuste la force d'attraction
