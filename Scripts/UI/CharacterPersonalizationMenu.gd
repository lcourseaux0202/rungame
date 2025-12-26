extends Control

@onready var world_preview: TextureRect = $VBoxContainer/WorldPreview
@onready var rail_preview: TextureRect = $VBoxContainer/RailPreview

@onready var world_color: ColorPickerButtonGroup = $VBoxContainer/WorldColor
@onready var rail_color: ColorPickerButtonGroup = $VBoxContainer/RailColor

@onready var back_button: Button = $HBoxContainer/BackButton
@onready var reset_button: Button = $HBoxContainer/ResetButton

@onready var skin_selector_p1: SkinSelector = $SkinSelectorsContainer/SkinSelectorP1
@onready var skin_selector_p2: SkinSelector = $SkinSelectorsContainer/SkinSelectorP2

var skins_pool : Array[SkinData]= []
var skin_cursor : int = -1

func _ready() -> void:
	world_color.color_changed.connect(_change_world_color)
	rail_color.color_changed.connect(_change_rail_color)
	back_button.pressed.connect(_back_to_menu)
	reset_button.pressed.connect(_reset_color)
	
	_change_world_color(Settings.world_color)
	_change_rail_color(Settings.rail_color)
	
	_load_skins()
	skin_selector_p1.set_up_skins_data(skins_pool, 1)
	skin_selector_p2.set_up_skins_data(skins_pool, 2)
	
func _load_skins():
	var path = "res://Resources/Skins/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				skins_pool.append(load(path + file_name))
			file_name = dir.get_next()

func _change_character_color(new_color : Color) -> void:
	skin_cursor += 1
	var current_skin : SkinData = skins_pool[skin_cursor]

func _change_aura_color(new_color : Color) -> void:
	pass

func _change_world_color(new_color : Color) -> void:
	world_preview.modulate = new_color
	Settings.world_color = new_color

func _change_rail_color(new_color : Color) -> void:
	rail_preview.modulate = new_color
	Settings.rail_color = new_color

func _back_to_menu() -> void :
	hide()
		
func _random_color() -> void :
	world_color.random_color()
	rail_color.random_color()

func _reset_color():
	skin_selector_p1.reset_skin()
	skin_selector_p2.reset_skin()
	
	Settings.world_color = Settings.WORLD_COLOR
	world_preview.modulate = Settings.WORLD_COLOR
	
	Settings.rail_color = Settings.RAIL_COLOR
	rail_preview.modulate = Settings.RAIL_COLOR
	
