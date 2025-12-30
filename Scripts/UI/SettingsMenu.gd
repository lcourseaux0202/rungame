class_name SettingsMenu extends Control

@onready var resolution_options: OptionButton = %ResolutionOptions
@onready var fullscreen_checkbox: CheckBox = %FullscreenCheckbox
@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var back_button: Button = %BackButton
@onready var back_to_menu_button: Button = %BackToMenuButton

const MAX_VALUE = 100.0 

signal settings_closed

func _ready() -> void:
	for resolution in Settings.resolutions.keys():
		resolution_options.add_item(resolution)
		
	fullscreen_checkbox.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	var master_vol = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	var music_vol = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	var sfx_vol = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	master_slider.value = master_vol * master_slider.max_value
	music_slider.value = music_vol * music_slider.max_value
	sfx_slider.value = sfx_vol * sfx_slider.max_value
	
	resolution_options.item_selected.connect(_change_resolution)
	fullscreen_checkbox.toggled.connect(_toggle_fullscreen)
	master_slider.value_changed.connect(_change_master_volume)
	music_slider.value_changed.connect(_change_music_volume)
	sfx_slider.value_changed.connect(_change_sfx_volume)
	back_button.pressed.connect(_close_menu)
	back_to_menu_button.pressed.connect(_back_to_menu)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close_menu()

func _change_resolution(index: int) -> void:
	var key = resolution_options.get_item_text(index)
	var new_resolution = Settings.resolutions[key]
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	fullscreen_checkbox.button_pressed = false
	
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

func open_menu(mode : int = 1):
	back_to_menu_button.visible = (mode == 1)
	show()

func _close_menu() -> void :
	visible = false
	get_tree().paused = false
	settings_closed.emit()
	
	
func _back_to_menu() -> void :
	_close_menu()
	var scene = load("res://Scenes/UI/StartMenu.tscn")
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		print("Erreur : Impossible de trouver le fichier de scène !")


func _on_visibility_changed() -> void:
	if resolution_options:
		resolution_options.grab_focus()
