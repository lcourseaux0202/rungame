extends Control

@onready var title_label: Label = $ColorRect/HBoxContainer/VBoxContainer/TitleLabel
@onready var start_button: Button = $ColorRect/HBoxContainer/VBoxContainer/StartButton
@onready var multiplayer_button: Button = $ColorRect/HBoxContainer/VBoxContainer/MultiplayerButton
@onready var custom_button: Button = $ColorRect/HBoxContainer/VBoxContainer/CustomButton
@onready var settings_button: Button = $ColorRect/HBoxContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $ColorRect/HBoxContainer/VBoxContainer/QuitButton
@onready var settings_menu : SettingsMenu = $SettingsMenu
@onready var select_character_menu: SelectCharacterMenu = $SelectCharacterMenu

@onready var multiplayer_scene = preload("res://Scenes/Game/Multiplayer.tscn")

func _ready() -> void:
	start_button.grab_focus()
	start_button.pressed.connect(_start_game)
	multiplayer_button.pressed.connect(_start_multiplayer)
	custom_button.pressed.connect(_custom_game)
	settings_button.pressed.connect(_settings_menu)
	quit_button.pressed.connect(_quit_game)
	
	settings_menu.settings_closed.connect(_reactivate_buttons)
	select_character_menu.personalization_closed.connect(_reactivate_buttons)

func _start_game() -> void:
	Settings.number_of_players = 1
	Settings.gamemode = Settings.GAMEMODE.SOLO
	get_tree().change_scene_to_packed(multiplayer_scene)
	
func _start_multiplayer() -> void:
	Settings.number_of_players = 2
	Settings.gamemode = Settings.GAMEMODE.MULTIPLAYER
	get_tree().change_scene_to_packed(multiplayer_scene)

func _custom_game() -> void:
	select_character_menu.show()
	_deactivate_buttons()
	
func _settings_menu() -> void:
	settings_menu.open_menu(0)
	_deactivate_buttons()

func _quit_game() -> void:
	get_tree().quit(0)

func _deactivate_buttons():
	start_button.focus_mode = Control.FOCUS_NONE
	multiplayer_button.focus_mode = Control.FOCUS_NONE
	custom_button.focus_mode = Control.FOCUS_NONE
	settings_button.focus_mode = Control.FOCUS_NONE
	quit_button.focus_mode = Control.FOCUS_NONE
	
func _reactivate_buttons():
	start_button.focus_mode = Control.FOCUS_ALL
	multiplayer_button.focus_mode = Control.FOCUS_ALL
	custom_button.focus_mode = Control.FOCUS_ALL
	settings_button.focus_mode = Control.FOCUS_ALL
	quit_button.focus_mode = Control.FOCUS_ALL
	
	start_button.grab_focus()
