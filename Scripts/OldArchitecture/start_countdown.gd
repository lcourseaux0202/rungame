extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Timer.time_left > 2 :
		$Label.text = "3"
	elif $Timer.time_left > 1 :
		$Label.text = "2"
	elif $Timer.time_left > 0 :
		$Label.text = "1"
	else :
		$Label.text = "GO!"

func _ready() -> void:
	$Timer.start()
		
func _on_timer_timeout() -> void:
	get_parent().get_node("Player").start()
	queue_free()
