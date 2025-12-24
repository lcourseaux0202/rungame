class_name UpgradeSelectMenu extends Control

@onready var background: ColorRect = $Background
@onready var continue_button: Button = $ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(_continue_pressed)
	
func _continue_pressed():
	hide()
	get_tree().paused = false

func reveal() -> void:
	background.modulate.a = 0.0
	show()
	var tween : Tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(background, "modulate", Color(Color.BLACK, 1.0), 1.0)
	
	await tween.finished
	get_tree().paused = true
