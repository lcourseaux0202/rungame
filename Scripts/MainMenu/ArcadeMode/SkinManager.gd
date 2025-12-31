@tool
class_name SkinManager extends GridContainer

var skins = []
@export var displayer : AnimatedTextureRect
@export var skins_buttons_size := 32
const SKINS_PATH = "res://Resources/Skins/"

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL 
	focus_entered.connect(_on_focus_entered)
	load_skins_from_folder()
	_create_skins_buttons()

func load_skins_from_folder():
	var dir = DirAccess.open(SKINS_PATH)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				var full_path = SKINS_PATH + file_name
				var skin_resource = load(full_path)
				
				if skin_resource:
					skins.append(skin_resource)
					print("Skin chargé : ", file_name)
			
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Erreur : Impossible d'accéder au dossier des skins.")

func _create_skins_buttons() -> void:
	for skin : SkinData in skins:
		var new_button : Button = Button.new()
		new_button.custom_minimum_size = Vector2(skins_buttons_size, skins_buttons_size)
		
		var diag_rect = Control.new()
		diag_rect.set_script(load("res://Scripts/MainMenu/ArcadeMode/DiagonalColorRect.gd"))
		
		diag_rect.color1 = skin.character_color  
		diag_rect.color2 = skin.aura_color
		
		diag_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		diag_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		new_button.add_child(diag_rect)
		new_button.pressed.connect(_display_skin.bind(new_button, skin))
		
		add_child(new_button)

func _display_skin(button_pressed : Button, skin : SkinData) -> void:
	displayer.modulate = skin.character_color
	Settings.set_selected_skin(0,skin)

func _on_focus_entered() -> void:
	if get_child_count() > 0:
		var first_button = get_child(0) as Button
		if first_button:
			first_button.grab_focus()
