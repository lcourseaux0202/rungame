class_name SelectCharacterMenu extends Control

@onready var back_button: Button = $HBoxContainer/BackButton
@onready var reset_button: Button = $HBoxContainer/ResetButton

@onready var skin_selector_p1: SkinSelector = $SkinSelectorsContainer/SkinSelectorP1
@onready var skin_selector_p2: SkinSelector = $SkinSelectorsContainer/SkinSelectorP2

var skins_pool : Array[SkinData]= []
var skin_cursor : int = -1

signal personalization_closed

func _ready() -> void:
	back_button.pressed.connect(_back_to_menu)
	reset_button.pressed.connect(_reset_color)
	
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


func _back_to_menu() -> void :
	personalization_closed.emit()
	hide()

func _reset_color():
	skin_selector_p1.reset_skin()
	skin_selector_p2.reset_skin()

func _on_visibility_changed() -> void:
	if skin_selector_p1 and visible: 
		skin_selector_p1.select()
