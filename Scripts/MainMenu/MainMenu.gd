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

@onready var resolution_options: OptionButton = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/DisplayOptions/ResolutionOptions
@onready var fullscreen_button: CheckButton = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/DisplayOptions/FullscreenButton
@onready var v_sync_button: CheckButton = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/DisplayOptions/VSyncButton

@onready var audio_options: VBoxContainer = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/AudioOptions
@onready var audio_button: Button = $MarginContainer/SettingsOptions/ButtonsContainer/MainButtons/AudioButton

@onready var master_volume: HSlider = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/AudioOptions/Master/MasterVolume
@onready var music_volume: HSlider = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/AudioOptions/Music/MusicVolume
@onready var sfx_volume: HSlider = $MarginContainer/SettingsOptions/ButtonsContainer/SubMenus/AudioOptions/SFX/SFXVolume

@onready var multiplayer_menu: VBoxContainer = $MarginContainer/MultiplayerMenu
@onready var local_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/ButtonsContainer/SubMenus/MultiplayerOptions/LocalButton

var multiplayer_scene = preload("res://Scenes/Game/Multiplayer.tscn")

const MAX_VALUE = 100.0 

func _ready() -> void:
	Settings.skin_changed.connect(_on_skin_changed)
	
	for resolution in Settings.resolutions.keys():
		resolution_options.add_item(resolution)
		
	fullscreen_button.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	resolution_options.disabled = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	var master_vol = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	var music_vol = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	var sfx_vol = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	master_volume.value = master_vol * master_volume.max_value
	music_volume.value = music_vol * music_volume.max_value
	sfx_volume.value = sfx_vol * sfx_volume.max_value
	
	resolution_options.item_selected.connect(_change_resolution)
	fullscreen_button.toggled.connect(_toggle_fullscreen)
	v_sync_button.toggled.connect(_toggle_v_sync)
	
	master_volume.value_changed.connect(_change_master_volume)
	music_volume.value_changed.connect(_change_music_volume)
	sfx_volume.value_changed.connect(_change_sfx_volume)

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
	menu_input_manager.open_menu(multiplayer_menu, local_button)
	#Settings.number_of_players = 2
	#Settings.gamemode = Settings.GAMEMODE.MULTIPLAYER
	#SceneTransition.go_to_scene(multiplayer_scene)

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

### Settings menu ###
func _change_resolution(index: int) -> void:
	var key = resolution_options.get_item_text(index)
	var new_resolution = Settings.resolutions[key]
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	fullscreen_button.button_pressed = false
	
	get_window().size = new_resolution
	
	center_window()

func center_window():
	var window = get_window()
	if window.mode == Window.MODE_WINDOWED:
		if not Engine.is_editor_hint():
			var screen_center = DisplayServer.screen_get_position(0) + DisplayServer.screen_get_size(0) / 2
			var window_size = window.get_size_with_decorations()
			window.position = screen_center - window_size / 2

func _toggle_fullscreen(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		resolution_options.disabled = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		center_window()
		resolution_options.disabled = false
		
func _toggle_v_sync(toggled_on : bool) -> void:
	if toggled_on :
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else :
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _change_master_volume(value: float) -> void:
	if value <= 0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		var db_val = linear_to_db(value / MAX_VALUE)
		AudioServer.set_bus_volume_db(0, db_val)

func _change_music_volume(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Music")
	if value <= 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / MAX_VALUE))

func _change_sfx_volume(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("SFX")
	if value <= 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / MAX_VALUE))


func _on_multiplayer_menu_visibility_changed() -> void:
	pass # Replace with function body.
