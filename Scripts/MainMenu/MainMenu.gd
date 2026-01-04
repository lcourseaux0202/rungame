class_name MainMenu extends Control

@onready var menu_input_manager: MenuInputManager = $MenuInputManager
@onready var title_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/TitleLabel

@onready var solo_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/MainButtons/SoloButton
@onready var solo_options: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/SubMenus/SoloOptions
@onready var arcade_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/SubMenus/SoloOptions/ArcadeButton

@onready var multiplayer_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/MainButtons/MultiplayerButton
@onready var multiplayer_options: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/SubMenus/MultiplayerOptions

@onready var arcade_menu: VBoxContainer = $MarginContainer/HBoxContainer/ArcadeMenu
@onready var skin_button: Button = $MarginContainer/HBoxContainer/ArcadeMenu/ButtonsContainer/MainButtons/SkinButton
@onready var skins_options: VBoxContainer = $MarginContainer/HBoxContainer/ArcadeMenu/ButtonsContainer/SubMenus/SkinsOptions

@onready var settings_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/MainButtons/SettingsButton
@onready var settings_options: VBoxContainer = $MarginContainer/SettingsOptions

@onready var display_options: VBoxContainer = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/DisplayOptions
@onready var display_button: Button = $MarginContainer/SettingsOptions/ButtonsContainer/MainButtons/DisplayButton
@onready var audio_options: VBoxContainer = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/AudioOptions
@onready var audio_button: Button = $MarginContainer/SettingsOptions/ButtonsContainer/MainButtons/AudioButton

var multiplayer_scene = preload("res://Scenes/Game/Multiplayer.tscn")

func _ready() -> void:
	Settings.skin_changed.connect(_on_skin_changed)

func _on_skin_changed(player_id, skin_resource):
	if player_id == 0 and skin_resource:
		var color : Color = skin_resource.character_color
		if color.get_luminance() < 0.1:
			color = color.lightened(0.1)
		title_label.label_settings.font_color = color
		

func _on_solo_button_pressed() -> void:
	menu_input_manager.open_menu(solo_options, solo_button)

func _on_multiplayer_button_pressed() -> void:
	menu_input_manager.open_menu(multiplayer_options, multiplayer_button)

func _on_back_button_pressed() -> void:
	menu_input_manager.close_menu()

func _on_arcade_button_pressed() -> void:
	menu_input_manager.open_menu(arcade_menu, arcade_button)

func _on_local_button_pressed() -> void:
	Settings.number_of_players = 2
	Settings.gamemode = Settings.GAMEMODE.MULTIPLAYER
	SceneTransition.go_to_scene(multiplayer_scene)

func _on_settings_button_pressed() -> void:
	menu_input_manager.open_menu(settings_options, settings_button)
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_skin_button_pressed() -> void:
	menu_input_manager.open_menu(skins_options, skin_button)

func _on_start_button_pressed() -> void:
	Settings.number_of_players = 1
	Settings.gamemode = Settings.GAMEMODE.SOLO
	SceneTransition.go_to_scene(multiplayer_scene)


func _on_display_button_pressed() -> void:
	menu_input_manager.open_menu(display_options, display_button)

func _on_audio_button_pressed() -> void:
	menu_input_manager.open_menu(audio_options, audio_button)
