extends VBoxContainer

@onready var ready_p_1_button: Button = $PlayersSettings/Player1/ReadyP1Button
@onready var ready_p_2_button: Button = $PlayersSettings/Player2/ReadyP2Button

@onready var player_1_preview: AnimatedTextureRect = $PlayersSettings/Player1/HBoxContainer/Player1Preview
@onready var press_button_1_label: Label = $PlayersSettings/Player1/HBoxContainer/PressButton1Label
@onready var player_2_preview: AnimatedTextureRect = $PlayersSettings/Player2/HBoxContainer/Player2Preview
@onready var press_button_2_label: Label = $PlayersSettings/Player2/HBoxContainer/PressButton2Label
@onready var skin_manager_p_1: SkinManager = $PlayersSettings/Player1/SkinManagerP1
@onready var skin_manager_p_2: SkinManager = $PlayersSettings/Player2/SkinManagerP2

@onready var start_button: Button = $HBoxContainer/StartButton

enum AssignState { PLAYER_1, PLAYER_2, SKIN_SELECTION, FINISHED }
var current_assign_state = AssignState.PLAYER_1
var can_assign : bool = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or not event.is_pressed() or not visible:
		return

	# On utilise une action générique "ui_accept" ou n'importe quelle touche
	if event.is_action_pressed("ui_accept") or event is InputEventKey or event is InputEventJoypadButton:
		match current_assign_state:
			AssignState.PLAYER_1:
				_assign_controls_to_player(1, event)
				current_assign_state = AssignState.SKIN_SELECTION
				player_1_preview.show()
				press_button_1_label.hide()
				press_button_2_label.show()
				ready_p_1_button.disabled = false
				ready_p_1_button.focus_mode = Control.FOCUS_ALL
				skin_manager_p_1.toggle_on(true)
				skin_manager_p_1.grab_focus()
				
			AssignState.PLAYER_2:
				_assign_controls_to_player(2, event)
				current_assign_state = AssignState.SKIN_SELECTION
				player_2_preview.show()
				press_button_2_label.hide()
				ready_p_2_button.disabled = false
				ready_p_2_button.focus_mode = Control.FOCUS_ALL
				skin_manager_p_2.toggle_on(true)
				skin_manager_p_2.grab_focus()

func _assign_controls_to_player(player_num: int, master_event: InputEvent):
	var suffix = "P" + str(player_num)
	var device_id = master_event.device
	
	var actions = ["Jump", "Boost", "FastFall"]
	
	for action_name in actions:
		var full_action_name = action_name + suffix
		
		InputMap.action_erase_events(full_action_name)
		
		if master_event is InputEventKey:
			_map_keyboard_action(full_action_name, player_num, action_name)
		else:
			
			_map_joypad_action(full_action_name, device_id, action_name)
			
func _map_keyboard_action(action_full: String, player_num: int, action_type: String):
	var new_event = InputEventKey.new()
	
	if player_num == 1:
		match action_type:
			"Jump":     new_event.keycode = KEY_UP
			"FastFall": new_event.keycode = KEY_DOWN
			"Boost":    new_event.keycode = KEY_RIGHT
	elif player_num == 2:
		match action_type:
			"Jump":     new_event.keycode = KEY_Z
			"FastFall": new_event.keycode = KEY_S
			"Boost":    new_event.keycode = KEY_D
	
	InputMap.action_add_event(action_full, new_event)
	print("Action clavier ", action_full, " mappée sur la touche : ", OS.get_keycode_string(new_event.keycode))

func _map_joypad_action(action_full: String, device: int, action_type: String):
	var new_event = InputEventJoypadButton.new()
	new_event.device = device
	
	match action_type:
		"Jump": new_event.button_index = JOY_BUTTON_A
		"Boost": new_event.button_index = JOY_BUTTON_X
		"FastFall": new_event.button_index = JOY_BUTTON_B
		
	InputMap.action_add_event(action_full, new_event)
	print("Action ", action_full, " mappée sur l'appareil ", device)

func _on_visibility_changed() -> void:
	if visible :
		current_assign_state = AssignState.PLAYER_1
		start_button.disabled = true
		ready_p_1_button.disabled = true
		ready_p_1_button.focus_mode = Control.FOCUS_NONE
		ready_p_2_button.disabled = true
		ready_p_2_button.focus_mode = Control.FOCUS_NONE
		skin_manager_p_1.toggle_on(false)
		skin_manager_p_2.toggle_on(false)
		player_1_preview.hide()
		player_2_preview.hide()
		press_button_1_label.show()
		press_button_2_label.hide()
		

func _on_ready_p_1_button_pressed() -> void:
	current_assign_state = AssignState.PLAYER_2
	ready_p_1_button.disabled = true
	ready_p_1_button.focus_mode = Control.FOCUS_NONE
	skin_manager_p_1.toggle_on(false)
	

func _on_ready_p_2_button_pressed() -> void:
	current_assign_state = AssignState.FINISHED
	ready_p_2_button.disabled = true
	ready_p_2_button.focus_mode = Control.FOCUS_NONE
	skin_manager_p_2.toggle_on(false)
	start_button.disabled = false
	start_button.grab_focus()
	
