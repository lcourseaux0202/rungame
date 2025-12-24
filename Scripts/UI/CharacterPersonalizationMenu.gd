extends Control

@onready var character_animation: AnimatedTextureRect = $VBoxContainer/CharacterAnimation
@onready var aura_animation: AnimatedTextureRect = $VBoxContainer/AuraAnimation
@onready var world_preview: TextureRect = $VBoxContainer/WorldPreview
@onready var rail_preview: TextureRect = $VBoxContainer/RailPreview

@onready var character_color: ColorPickerButtonGroup = $VBoxContainer/CharacterColor
@onready var aura_color: ColorPickerButtonGroup = $VBoxContainer/AuraColor
@onready var world_color: ColorPickerButtonGroup = $VBoxContainer/WorldColor
@onready var rail_color: ColorPickerButtonGroup = $VBoxContainer/RailColor

@onready var back_button: Button = $HBoxContainer/BackButton
@onready var random_button: Button = $HBoxContainer/RandomButton
@onready var reset_button: Button = $HBoxContainer/ResetButton

func _ready() -> void:
	character_color.color_changed.connect(_change_character_color)
	aura_color.color_changed.connect(_change_aura_color)
	world_color.color_changed.connect(_change_world_color)
	rail_color.color_changed.connect(_change_rail_color)
	back_button.pressed.connect(_back_to_menu)
	random_button.pressed.connect(_random_color)
	reset_button.pressed.connect(_reset_color)
	
	_change_character_color(Settings.character_color)
	_change_aura_color(Settings.aura_color)
	_change_world_color(Settings.world_color)
	_change_rail_color(Settings.rail_color)

func _change_character_color(new_color : Color) -> void:
	character_animation.modulate = new_color
	Settings.character_color = new_color
	
	var mat = character_animation.material as ShaderMaterial
	if mat:
		if new_color.get_luminance() <= 0.05:
			mat.set_shader_parameter("line_thickness", 1.0)
		else:
			mat.set_shader_parameter("line_thickness", 0.0)

func _change_aura_color(new_color : Color) -> void:
	aura_animation.modulate = new_color
	Settings.aura_color = new_color
	
	var mat = aura_animation.material as ShaderMaterial
	if mat:
		if new_color.get_luminance() <= 0.05:
			mat.set_shader_parameter("line_thickness", 1.0)
		else:
			mat.set_shader_parameter("line_thickness", 0.0)

func _change_world_color(new_color : Color) -> void:
	world_preview.modulate = new_color
	Settings.world_color = new_color

func _change_rail_color(new_color : Color) -> void:
	rail_preview.modulate = new_color
	Settings.rail_color = new_color

func _back_to_menu() -> void :
	hide()
		
func _random_color() -> void :
	character_color.random_color()
	aura_color.random_color()
	world_color.random_color()
	rail_color.random_color()

func _reset_color():
	Settings.character_color = Settings.CHARACTER_COLOR
	character_animation.modulate = Settings.CHARACTER_COLOR
	
	Settings.aura_color = Settings.AURA_COLOR
	aura_animation.modulate = Settings.AURA_COLOR
	
	Settings.world_color = Settings.WORLD_COLOR
	world_preview.modulate = Settings.WORLD_COLOR
	
	Settings.rail_color = Settings.RAIL_COLOR
	rail_preview.modulate = Settings.RAIL_COLOR
	
