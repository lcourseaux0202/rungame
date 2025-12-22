extends Control

@onready var start_button: Button = $ColorRect/VBoxContainer/StartButton
@onready var game_scene = preload("res://Scenes/NewArchitecture/Game/Game.tscn")

func _ready() -> void:
	start_button.pressed.connect(_start_game)

func _start_game():
	get_tree().change_scene_to_packed(game_scene)
