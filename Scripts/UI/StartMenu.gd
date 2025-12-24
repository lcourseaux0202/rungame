extends Control

@onready var start_button: Button = $ColorRect/VBoxContainer/StartButton
@onready var custom_button: Button = $ColorRect/VBoxContainer/CustomButton
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton
@onready var game_scene = preload("res://Scenes/Game/Game.tscn")
@onready var customization_scene = preload("res://Scenes/UI/CharacterPersonalizationMenu.tscn")

func _ready() -> void:
	start_button.pressed.connect(_start_game)
	custom_button.pressed.connect(_custom_game)
	quit_button.pressed.connect(_quit_game)
	

func _start_game() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _custom_game() -> void:
	get_tree().change_scene_to_packed(customization_scene)

func _quit_game() -> void:
	get_tree().quit(0)
