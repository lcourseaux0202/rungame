class_name CardMenu extends Control

@onready var booster_carousel: CarouselContainer = $BoosterCarousel
@onready var boosters_container: Control = $BoosterCarousel/BoostersContainer
@onready var card_carousel: CarouselContainer = $CardCarousel
@onready var cards_container: Control = $CardCarousel/CardsContainer
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var orbs_label: Label = $MarginContainer/Control/OrbsLabel
@onready var explanation_label: Label = $MarginContainer/ExplanationLabel

var tween : Tween

var card_pool : Array[CardData] = []
var booster_pool : Array[BoosterData] = []

var card_for_this_booster : int
var cards_gained : int

enum CardMenuState{
	Booster,
	Card
}
var current_state : CardMenuState = CardMenuState.Booster

var players : Array[Player]
var receiver_index : int

func set_players(ordered_players : Array[Player]):
	players = ordered_players
	receiver_index = 0
	orbs_label.text = "Orbes : " + str(players[receiver_index].xp)
	orbs_label.show()
	explanation_label.text = "Joueur " + str(players[receiver_index].player_id + 1) + " : choisissez un booster."
	explanation_label.add_theme_color_override("font_color", players[receiver_index].skin.character_color)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		if current_state == CardMenuState.Card : 
			card_carousel._left() 
		else :
			booster_carousel._left()
	if event.is_action_pressed("ui_right"):
		if current_state == CardMenuState.Card : 
			card_carousel._right() 
		else :
			booster_carousel._right()

func _ready() -> void:
	load_all_cards()
	load_all_boosters()

func reveal_menu() -> void :
	modulate.a = 0.0
	
	card_carousel.position = get_viewport_rect().size / 2.0
	card_carousel.hide()
	
	booster_carousel.position = get_viewport_rect().size / 2.0
	booster_carousel.show()
	
	for booster_data in booster_pool:
		spawn_booster(booster_data)
		
	show()
	
	if boosters_container.get_child_count() > 0:
		boosters_container.get_child(0).grab_focus()
		
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().paused = true

func load_all_cards():
	var path = "res://Resources/Cards/"
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir():
				var clean_name = file_name.replace(".remap", "").replace(".import", "")
				
				if clean_name.ends_with(".tres"):
					var full_path = path + clean_name
					
					var already_loaded = false
					for card in card_pool:
						if card.resource_path == full_path:
							already_loaded = true
							break
					
					if not already_loaded:
						var card_res = load(full_path)
						if card_res:
							card_pool.append(card_res)
							
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Erreur : Impossible d'accéder au dossier des cartes : ", path)
func load_all_boosters():
	var path = "res://Resources/Boosters/"
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir():
				var clean_name = file_name.replace(".remap", "").replace(".import", "")
				
				if clean_name.ends_with(".tres"):
					var full_path = path + clean_name
					
					var already_loaded = false
					for card in card_pool:
						if card.resource_path == full_path:
							already_loaded = true
							break
					
					if not already_loaded:
						var card_res = load(full_path)
						if card_res:
							booster_pool.append(card_res)
							
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Erreur : Impossible d'accéder au dossier des cartes : ", path)

func _open_booster(booster : Booster) -> void :
	if players[receiver_index].xp >= booster.price :
		orbs_label.hide()
		
		booster.reparent(booster_carousel)
		booster.animation_player.play("OpeningAnimation")

		_delete_all_boosters()
		_delete_all_cards()

		card_for_this_booster = booster.pick_number

		explanation_label.text = "Vous pouvez encore choisir [" + str(card_for_this_booster) + "] carte(s)."

		for i in range(booster.card_number):
			spawn_card(pick_random_card_by_weight())

		card_carousel.show()
		animation.play("RevealCardsAnimation")
		@warning_ignore("integer_division")
		card_carousel.selected_index = cards_container.get_child_count() / 2
		current_state = CardMenuState.Card
		await booster.animation_player.animation_finished
		booster.queue_free()

func spawn_card(card_res: CardData):
	if card_res != null:
		var card_scene = preload("res://Scenes/CardsUpgrades/Card.tscn")
		var card_instance : Card = card_scene.instantiate()
		card_instance.modulate.a = 0
		cards_container.add_child(card_instance)
		card_instance.load_card(card_res)
		card_instance.card_bought.connect(_handle_card_gained)
		card_instance.receiver = players[receiver_index]
	
func spawn_booster(booster_res: BoosterData):
	if booster_res != null:
		var booster_scene = preload("res://Scenes/CardsUpgrades/Booster.tscn")
		var booster_instance : Booster = booster_scene.instantiate()
		booster_instance.modulate.a = 0
		boosters_container.add_child(booster_instance)
		booster_instance.load_booster(booster_res)
		booster_instance.pressed.connect(_open_booster.bind(booster_instance))

func _handle_card_gained(card : Card) -> void:
	card.reparent(card_carousel)
	cards_gained += 1
	explanation_label.text = "Vous pouvez encore choisir [" + str(card_for_this_booster - cards_gained) + "] carte(s)."
	if cards_gained >= card_for_this_booster :
		next_turn()

func next_turn():
	_delete_all_cards()
	cards_gained = 0
	receiver_index += 1
	if receiver_index >= players.size():
		_close_menu()
	else :
		orbs_label.text = "Orbes : " + str(players[receiver_index].xp)
		orbs_label.show()
		
		explanation_label.text = "Joueur " + str(players[receiver_index].player_id + 1) + " : choisissez un booster."
		explanation_label.add_theme_color_override("font_color", players[receiver_index].skin.character_color)
		
		card_carousel.position = get_viewport_rect().size / 2.0
		card_carousel.hide()
		
		booster_carousel.position = get_viewport_rect().size / 2.0
		booster_carousel.show()
	
		for booster_data in booster_pool:
			spawn_booster(booster_data)
		
		if boosters_container.get_child_count() > 0:
			boosters_container.get_child(0).grab_focus()
		
		current_state = CardMenuState.Booster

func _close_menu():
	if tween :
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	get_tree().paused = false
	current_state = CardMenuState.Booster
	cards_gained = 0
	receiver_index = 0

func _delete_all_cards() -> void :
	for card in cards_container.get_children():
		cards_container.remove_child(card)
		card.queue_free()

func _delete_all_boosters() -> void :
	for booster in boosters_container.get_children():
		boosters_container.remove_child(booster)
		booster.queue_free()

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
