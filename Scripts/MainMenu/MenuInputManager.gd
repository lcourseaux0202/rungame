class_name MenuInputManager extends Node

@export var base_menu: MenuConfigResource
@export var popup_menus: Array[MenuConfigResource]

var popup_menu_stack : Array

var cur_default_button : NodePath
var last_hovered_node : Control

enum ControlType{ FocusInput, HoverInput }
var last_control_type : ControlType = ControlType.HoverInput

func _ready() -> void:
	cur_default_button = base_menu.default_button
	_setup_nodes_and_buttons(get_node(base_menu.menu_parent), true)
	for menu in popup_menus:
		_setup_nodes_and_buttons(get_node(menu.menu_parent), false)

func _setup_nodes_and_buttons(node : Control, is_base_menu : bool) -> void :
	if !_is_hover_focusable(node):
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else :
		if not node.mouse_entered.is_connected(_on_menubutton_hovered):
			node.mouse_entered.connect(_on_menubutton_hovered.bind(node))
		if not is_base_menu:
			node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			node.focus_mode =Control.FOCUS_NONE
	for child in node.get_children():
		if child is Control:
			_setup_nodes_and_buttons(child, is_base_menu)
	
func _is_hover_focusable(node : Control) -> bool:
	return node is BaseButton or node is Range or node is ItemList or node is Tree or node is TextEdit or node is LineEdit or node is SkinManager

func _on_menubutton_hovered(menubutton : Control) -> void:
	if menubutton.mouse_filter == Control.MOUSE_FILTER_STOP:
		last_hovered_node = menubutton
		
func _enable_disable_menu(menu : Array[NodePath], enable : bool) -> void :
	for path in menu :
		for node : Control in get_node(path).get_children():
			if _is_hover_focusable(node):
				node.focus_mode = Control.FOCUS_ALL if enable else Control.FOCUS_NONE
				node.mouse_filter = Control.MOUSE_FILTER_STOP if enable else Control.MOUSE_FILTER_IGNORE
				if not enable:
					node.release_focus()
					if last_hovered_node == node :
						last_hovered_node = null
				_enable_disable_menu([node.get_path()], enable)
				
func open_menu(menu_node : Control, opener_button : Control = null) -> void :
	var menu_resource = _find_menu_data(menu_node)
	if not menu_resource:
		push_warning("Menu doesn't exist")
		return
		
	_enable_disable_menu(menu_resource.button_parents, true)
	if popup_menu_stack.size() > 0:
		_enable_disable_menu(popup_menu_stack.back()["config_resource"].button_parents, false)
	else : 
		_enable_disable_menu(base_menu.button_parents, false)
	
	get_node(menu_resource.menu_parent).visible = true
	var anim_player_node : AnimationPlayer = null if !menu_resource.anim_player else get_node(menu_resource.anim_player)
	if anim_player_node and menu_resource.show_anim != "" and anim_player_node.has_animation(menu_resource.show_anim):
		anim_player_node.play(menu_resource.show_anim)
		await anim_player_node.animation_finished
	
	popup_menu_stack.append({
		"config_resource" : menu_resource,
		"opener_button" : opener_button
	})
	
	cur_default_button = menu_resource.default_button
	if last_control_type == ControlType.FocusInput :
		get_node(cur_default_button).grab_focus()
	
	

func _find_menu_data(menu_node : Control) -> MenuConfigResource :
	if get_node(base_menu.menu_parent) == menu_node :
		return base_menu
		
	for data in popup_menus :
		if get_node(data.menu_parent) == menu_node:
			return data
	
	return null

func close_menu():
	var menu_being_closed = popup_menu_stack.pop_back()
	var closing_menu_resource : MenuConfigResource = menu_being_closed["config_resource"]
	var closing_menu_opener_button : Control = menu_being_closed["opener_button"]
	
	_enable_disable_menu(closing_menu_resource.button_parents, false)
	
	var anim_player_node : AnimationPlayer = null if !closing_menu_resource.anim_player else get_node(closing_menu_resource.anim_player)
	if anim_player_node and closing_menu_resource.hide_anim != "" and anim_player_node.has_animation(closing_menu_resource.hide_anim):
		anim_player_node.play(closing_menu_resource.hide_anim)
		await anim_player_node.animation_finished
	else :
		get_node(closing_menu_resource.menu_parent).visible = false
		
	var current_config: MenuConfigResource
	if popup_menu_stack.size() > 0:
		current_config = popup_menu_stack.back()["config_resource"]
	else :
		current_config = base_menu
	_enable_disable_menu(current_config.button_parents, true)
	
	cur_default_button = current_config.default_button
	last_hovered_node = get_node(cur_default_button)
	if last_control_type == ControlType.FocusInput:
		if closing_menu_opener_button:
			closing_menu_opener_button.grab_focus()
		else :
			get_node(cur_default_button).grab_focus()
			

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion :
		if last_control_type != ControlType.FocusInput :
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			get_viewport().set_input_as_handled()
			if last_hovered_node and is_instance_valid(last_hovered_node):
				last_hovered_node.grab_focus()
				last_hovered_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			elif cur_default_button :
				get_node(cur_default_button).grab_focus()
			last_control_type = ControlType.FocusInput
			
		if Input.is_action_just_pressed("ui_cancel") and popup_menu_stack.size() > 0:
			close_menu()
			
	elif event is InputEventMouseMotion or event is InputEventMouseButton:
		if last_control_type != ControlType.HoverInput:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			var focused = get_viewport().gui_get_focus_owner()
			if focused :
				focused.release_focus()
			if last_hovered_node:
				last_hovered_node.mouse_filter = Control.MOUSE_FILTER_STOP
			last_control_type = ControlType.HoverInput
