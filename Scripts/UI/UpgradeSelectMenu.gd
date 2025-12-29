class_name UpgradeSelectMenu extends Control

@onready var background: ColorRect = $Background
@onready var label_orb_stock: Label = $LabelOrbStock
@onready var cards_container: Node2D = $CardsContainer
@onready var selected_card_container: Node2D = $SelectedCardContainer
@onready var continue_button: Button = $HBoxContainer/ContinueButton
@onready var reroll_button: Button = $HBoxContainer/RerollButton

var card_pool := []
var displayed_cards_number := 2
var receivers : Array[Player]
var current_receiver: Player
var current_receiver_index := 0
var base_reroll_price := 10
var gamemode : Settings.GAMEMODE
var reroll_price
var tween : Tween

func _ready() -> void:
	continue_button.hide()
	label_orb_stock.hide()
	reroll_button.hide()
	continue_button.pressed.connect(_continue_pressed)
	reroll_button.pressed.connect(_reroll_pressed)
	load_all_cards()

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

func _continue_pressed():
	_remove_all_displayed_cards()
	_close()
	
func _reroll_pressed():
	if current_receiver.xp >= reroll_price :
		_remove_all_displayed_cards()
		_draw_cards()
		current_receiver.xp -= reroll_price
		reroll_price = int(reroll_price * 1.1)
		reroll_button.text = "Nouveau tirage (" + str(reroll_price) + ")"
		label_orb_stock.text = "Orbes : " + str(current_receiver.xp)
	else :
		if tween:
			tween.kill()
		tween = create_tween().set_parallel(true)
		reroll_button.modulate = Color.RED
		label_orb_stock.modulate = Color.RED
		tween.tween_property(reroll_button, "modulate", Color.WHITE, 0.4)
		tween.tween_property(label_orb_stock, "modulate", Color.WHITE, 0.4)
		return false
	
func _close():
	get_tree().paused = false
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(Color.BLACK, 0.0), 0.5)
	await tween.finished
	label_orb_stock.hide()
	continue_button.hide()
	hide()

func reveal() -> void:
	_remove_all_displayed_cards()
	reroll_price = (base_reroll_price + randi_range(-base_reroll_price * 0.1, base_reroll_price * 0.1)) 
	reroll_button.text = "Nouveau tirage (" + str(reroll_price) + ")"
	modulate.a = 0.0
	show()
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(Color.WHITE, 1.0), 1.0)
	await tween.finished
	continue_button.show()
	_draw_cards()
	if Settings.is_gamemode_solo():
		label_orb_stock.show()
		label_orb_stock.text = "Orbes : " + str(current_receiver.xp)
		reroll_button.show()
	get_tree().paused = true

func _draw_cards() -> void:
	for card in cards_container.get_children() :
		card.queue_free()
	if Settings.is_gamemode_solo():
		for i in range(displayed_cards_number):
			spawn_card(pick_random_card_by_weight(), _get_card_emplacement_position(i))
	else :
		for i in range(receivers.size()):
			spawn_card(pick_random_card_by_weight(), _get_card_emplacement_position(i))

func pick_random_card_by_weight():
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
	
func _get_card_emplacement_position(index : int) -> Vector2:
	if gamemode == Settings.GAMEMODE.SOLO :
		return Vector2((index + 1) * (get_viewport_rect().size.x / (displayed_cards_number + 1)),(get_viewport_rect().size.y / 2))
	else :
		return Vector2((index + 1) * (get_viewport_rect().size.x / (receivers.size() + 1)),(get_viewport_rect().size.y / 2))
	
func spawn_card(card_res: CardData, spawn_position : Vector2):
	if card_res != null:
		var card_scene = preload("res://Scenes/CardsUpgrades/BaseCardUpgrade.tscn")
		var card_instance : CardUpgrade = card_scene.instantiate()
		card_instance.visible = false
		card_instance.global_position = spawn_position
		cards_container.add_child(card_instance)
		card_instance.load_card(card_res, (gamemode == Settings.GAMEMODE.SOLO))
		card_instance.visible = true
		card_instance.pressed.connect(_on_card_pressed)

func _on_card_pressed(card : CardUpgrade) -> void:
	if gamemode == Settings.GAMEMODE.MULTIPLAYER :
		card.reparent(selected_card_container)
		card.apply_modifier_on_player(current_receiver)
		_set_next_receiver()
	else :
		if card.can_purchase_card(current_receiver):
			card.reparent(selected_card_container)
			card.apply_modifier_on_player(current_receiver)
			_set_next_receiver()
		else :
			if tween:
				tween.kill()
			tween = create_tween().set_parallel(true)
			label_orb_stock.modulate = Color.RED
			tween.tween_property(label_orb_stock, "modulate", Color.WHITE, 0.4)

func _set_next_receiver():
	current_receiver_index += 1
	if current_receiver_index >= len(receivers):
		current_receiver_index = 0
		if gamemode == Settings.GAMEMODE.MULTIPLAYER and current_receiver == receivers[-1] :
			_remove_all_displayed_cards()
			_close()
			
	current_receiver = receivers[current_receiver_index]
	label_orb_stock.text = "Orbes : " + str(current_receiver.xp)

func _remove_all_displayed_cards():
	for card : CardUpgrade in cards_container.get_children():
		card.make_disappear()
	
func _get_card(index : int) -> CardUpgrade:
	return cards_container.get_child(index)

func set_card_receivers(players : Array[Player]):
	receivers = players
	current_receiver_index = 0
	current_receiver = receivers[current_receiver_index]
