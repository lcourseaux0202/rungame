class_name SkinSelector extends Control

var skins_availables : Array[SkinData]
var skin_cursor = 0
var player : int = 1
var default_skin = "Glacier"
var default_skin_cursor : int

@onready var next_skin: Button = $GridContainer/HBoxContainer/NextSkin
@onready var previous_skin: Button = $GridContainer/HBoxContainer/PreviousSkin
@onready var character_animation: AnimatedTextureRect = $GridContainer/VBoxContainer/CharacterAnimation
@onready var aura_animation: AnimatedTextureRect = $GridContainer/VBoxContainer/AuraAnimation
@onready var label_skin: Label = $GridContainer/LabelSkin

func set_up_skins_data(skin_pool : Array[SkinData], player_index : int) -> void:
	skins_availables = skin_pool
	next_skin.pressed.connect(_next_skin)
	previous_skin.pressed.connect(_previous_skin)
	player = player_index
	var starting_index = 0
	for i in range(skins_availables.size()):
		if skins_availables[i].skin_name == default_skin:
			starting_index = i
			break
	default_skin_cursor = starting_index
	skin_cursor = default_skin_cursor
	_display_skin(default_skin_cursor)
	
func reset_skin():
	_display_skin(default_skin_cursor)
	
func _next_skin():
	if skins_availables.is_empty():
		return
	previous_skin.disabled = false
	if skin_cursor < skins_availables.size() - 1 :
		skin_cursor += 1
		_display_skin(skin_cursor)
		if skin_cursor == skins_availables.size() - 1 :
			next_skin.disabled = true
		
	
func _previous_skin():
	if skins_availables.is_empty():
		return
	next_skin.disabled = false
	if skin_cursor > 0 :
		skin_cursor -= 1
		_display_skin(skin_cursor)
		if skin_cursor == 0 :
			previous_skin.disabled = true
		
		
func _display_skin(index : int):
	var current_skin : SkinData = skins_availables[index]
	character_animation.modulate = current_skin.character_color
	aura_animation.modulate = current_skin.aura_color
	label_skin.text = current_skin.skin_name
	
	Settings.selected_skins[player] = current_skin

func select() -> void:
	previous_skin.grab_focus()
