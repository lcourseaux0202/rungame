@tool
class_name ColorPickerButtonGroup extends Control

@export var white_texture : Texture2D
@export var left_button_icon : Texture2D
@export var right_button_icon : Texture2D
@export var preview := true
@export var separation := 1
@export_range(0.0,1.0) var base_color := 0.0
@export_range(0.01,0.10,0.01) var step := 0.1

@onready var color_preview: TextureRect = $HBoxContainer/ColorPreview

@onready var previous_color: Button = $HBoxContainer/PreviousColor
@onready var next_color: Button = $HBoxContainer/NextColor

@onready var separator_1: VSeparator = $HBoxContainer/Separator1
@onready var separator_2: VSeparator = $HBoxContainer/Separator2

var selected_color := self.base_color

signal color_changed(color: Color)

func _ready() -> void:
	next_color.pressed.connect(_next_color)
	previous_color.pressed.connect(_previous_color)

func _process(delta: float) -> void:
	if white_texture:
		color_preview.texture = white_texture
	if left_button_icon:
		previous_color.icon = left_button_icon
	if right_button_icon:
		next_color.icon = right_button_icon
	
	color_preview.visible = preview
	separator_1.add_theme_constant_override("separation", separation)
	separator_2.add_theme_constant_override("separation", separation)

func _next_color() -> void:
	selected_color = clamp(selected_color + step, 0, 1)
	var new_color = Color.from_hsv(selected_color, 1.0, 1.0)
	color_preview.modulate = new_color
	color_changed.emit(new_color)
	
func _previous_color() -> void:
	selected_color = clamp(selected_color - step, 0, 1)
	var new_color = Color.from_hsv(selected_color, 1.0, 1.0)
	color_preview.modulate = new_color
	color_changed.emit(new_color)
	
func random_color() -> void :
	selected_color = randf_range(0.0,1.0)
	var new_color = Color.from_hsv(selected_color, 1.0, 1.0)
	color_preview.modulate = new_color
	color_changed.emit(new_color)
