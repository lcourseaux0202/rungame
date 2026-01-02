class_name CardSelectionMenu extends Control

@onready var cards_button_container: Control = $MarginContainer/CardsButtonContainer
@onready var refresh_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/RefreshButton

var tween : Tween
var receivers : Array[Player] = []
var card_pool : Array[CardData] = []
var displayed_cards_number := 3
var last_focused_node: Control = null

func _ready() -> void:
	load_all_cards()
	cards_button_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	open()
	
func _on_focus_changed(node: Control) -> void:
	if is_ancestor_of(node):
		last_focused_node = node
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") or \
	   event.is_action_pressed("ui_right") or \
	   event.is_action_pressed("ui_up") or \
	   event.is_action_pressed("ui_down"):
		
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		if last_focused_node and not get_viewport().gui_get_focus_owner():
			last_focused_node.grab_focus()

	elif event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func load_all_cards():
	var path = "res://Resources/Cards/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				card_pool.append(load(path + file_name))
			file_name = dir.get_next()

func open() -> void :
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	await tween.finished
	
	_draw_cards()

func close() -> void :
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	await tween.finished
	
	visible = false
	
func _draw_cards() -> void:
	for child in cards_button_container.get_children():
		cards_button_container.remove_child(child)
		child.queue_free()
		
	var spawned_cards = []
	
	if Settings.is_gamemode_solo():
		for i in range(displayed_cards_number):
			var card = spawn_card(pick_random_card_by_weight())
			if card:
				spawned_cards.append(card)
	else :
		for i in range(receivers.size()):
			var card = spawn_card(pick_random_card_by_weight())
			if card:
				spawned_cards.append(card)

	for i in range(spawned_cards.size()):
		var current_card = spawned_cards[i]
		if i > 0:
			current_card.focus_neighbor_left = spawned_cards[i-1].get_path()
		if i < spawned_cards.size() - 1:
			current_card.focus_neighbor_right = spawned_cards[i+1].get_path()
		
		current_card.focus_neighbor_bottom = get_node("MarginContainer/VBoxContainer/HBoxContainer/FinishButton").get_path()

	_reposition_cards()
	
	await get_tree().process_frame
	
	var cards = cards_button_container.get_children()
	for card : Card in cards:
		card.modulate.a = 1.0
		card.animation_player.play("RevealAnimation")

	if cards.size() > 0:
		var first_card = cards[0]
		first_card.grab_focus()
		last_focused_node = first_card # Mémorise le focus initial


func spawn_card(card_res: CardData) -> Card:
	if card_res != null:
		var card_scene = preload("res://Scenes/CardsUpgrades/Card.tscn")
		var card_instance : Card = card_scene.instantiate()
		card_instance.modulate.a = 0
		cards_button_container.add_child(card_instance)
		card_instance.load_card(card_res, Settings.is_gamemode_solo())
		return card_instance
	return null

func _reposition_cards() -> void:
	var cards = cards_button_container.get_children()
	var count = cards.size()
	if count == 0: return
	
	var container_width = cards_button_container.size.x
	var container_height = cards_button_container.size.y
	
	var card_width = 288.0 
	
	var total_usable_width = container_width - card_width
	var spacing = 0.0
	
	if count > 1:
		spacing = total_usable_width / (count - 1)
	else:
		spacing = 0
	
	var total_cards_width = (spacing * (count - 1)) + card_width
	var start_x = (container_width - total_cards_width) / 2

	for i in range(count):
		var card = cards[i]
		
		var target_y = container_height / 2
		var target_x = start_x + (i * spacing)
		
		card.position = Vector2(target_x, target_y - (card.size.y / 2))
		card.rotation_degrees = 0
		
		if card.get("Visual"):
			card.visual.pivot_offset = card.visual.size / 2
		
func pick_random_card_by_weight() -> CardData:
	var total_weight = 0
	for card_data : CardData in card_pool:
		total_weight += card_data.get_rarity_weight()
	
	var roll = randf() * total_weight
	var cursor = 0
	
	for card_data : CardData in card_pool:
		cursor += card_data.get_rarity_weight()
		if roll <= cursor:
			return card_data
	return null


func _on_refresh_button_pressed() -> void:
	_draw_cards()
	refresh_button.grab_focus()
