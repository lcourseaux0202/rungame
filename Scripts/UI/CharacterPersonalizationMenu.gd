extends Control

@onready var character_color: ColorPicker = $CharacterColor
@onready var aura_color: ColorPicker = $AuraColor

@onready var character_animation: AnimatedTextureRect = $VBoxContainer/HBoxContainer/CharacterAnimation
@onready var aura_animation: AnimatedTextureRect = $VBoxContainer/HBoxContainer2/AuraAnimation
@onready var back_button: Button = $BackButton

func _ready() -> void:
	character_color.color_changed.connect(_change_character_color)
	aura_color.color_changed.connect(_change_aura_color)
	back_button.pressed.connect(_back_to_menu)

func _change_character_color(new_color : Color) -> void:
	character_animation.modulate = new_color
	Settings.character_color = character_color.color
	
	var mat = character_animation.material as ShaderMaterial
	if mat:
		if new_color.get_luminance() <= 0.05:
			mat.set_shader_parameter("line_thickness", 1.0)
		else:
			mat.set_shader_parameter("line_thickness", 0.0)

func _change_aura_color(new_color : Color) -> void:
	aura_animation.modulate = new_color
	Settings.aura_color = aura_color.color
	
	var mat = aura_animation.material as ShaderMaterial
	if mat:
		if new_color.get_luminance() <= 0.05:
			mat.set_shader_parameter("line_thickness", 1.0)
		else:
			mat.set_shader_parameter("line_thickness", 0.0)

func _back_to_menu() -> void :
	var scene = load("res://Scenes/UI/StartMenu.tscn")
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		print("Erreur : Impossible de trouver le fichier de scène !")
