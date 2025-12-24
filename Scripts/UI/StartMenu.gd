extends Control

@onready var title_label: Label = $ColorRect/VBoxContainer/TitleLabel
@onready var start_button: Button = $ColorRect/VBoxContainer/StartButton
@onready var custom_button: Button = $ColorRect/VBoxContainer/CustomButton
@onready var settings_button: Button = $ColorRect/VBoxContainer/SettingsButton
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton
@onready var game_scene = preload("res://Scenes/Game/Game.tscn")
@onready var settings_menu : SettingsMenu = $SettingsMenu
@onready var customization_menu: Control = $CustomizationMenu


func _ready() -> void:
	start_button.pressed.connect(_start_game)
	custom_button.pressed.connect(_custom_game)
	settings_button.pressed.connect(_settings_menu)
	quit_button.pressed.connect(_quit_game)
	
func _process(delta: float) -> void:
	title_label.modulate = Settings.character_color


func _start_game() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _custom_game() -> void:
	customization_menu.show()
	
func _settings_menu() -> void:
	settings_menu.open_menu(0)

func _quit_game() -> void:
	get_tree().quit(0)
