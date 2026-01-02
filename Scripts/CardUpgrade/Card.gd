class_name Card extends Button

@onready var visual: Control = $Visual
@onready var card_layout: TextureRect = $Visual/CardLayout
@onready var card_illustration: TextureRect = $Visual/CardLayout/CardIllustration

@onready var card_title_label: Label = $Visual/CardLayout/HBoxContainer/VBoxContainer/CardTitleLabel
@onready var card_description_label: Label = $Visual/CardLayout/HBoxContainer/VBoxContainer/CardDescriptionLabel

@onready var animation: AnimationPlayer = $AnimationPlayer

var receiver: Player = null
var stats : CardData
var rarity_weight

signal card_bought(card : Card)

func _ready() -> void:
	pressed.connect(_buy_card)

func set_receiver(player : Player):
	receiver = player

func load_card(data : CardData):
	name = data.card_name
	card_illustration.texture = data.illustration
	stats = data
	card_title_label.text = data.card_name
	card_description_label.text = data.description
	rarity_weight = data.get_rarity_weight()
	
	if data.illustration:
		card_illustration.texture = data.illustration
	
	var color : Color = Color.BLACK
	match data.rarity :
		CardData.RARITY.COMMON :
			color = Color.BEIGE
		CardData.RARITY.UNCOMMON :
			color = Color.LIGHT_GREEN
		CardData.RARITY.RARE :
			color = Color.DODGER_BLUE
		CardData.RARITY.EPIC :
			color = Color.MAGENTA
		CardData.RARITY.LEGENDARY :
			color = Color.GOLD
			
	card_layout.self_modulate = color

func _buy_card() -> void :
	card_bought.emit(self)
	_apply_modifier()
	animation.play("BuyAnimation")
	await animation.animation_finished
	queue_free()

func _apply_modifier():
	receiver.base_speed = min(receiver.base_speed + stats.base_speed_modifier, receiver.max_speed)
	receiver.max_speed += stats.max_speed_modifier
	receiver.acceleration += stats.acceleration_modifier
	receiver.deceleration = max(receiver.deceleration + stats.deceleration_modifier, 0)
	receiver.boost_deceleration = max(receiver.boost_deceleration + stats.boost_deceleration_modifier, 0)
	receiver.rail_deceleration += stats.rail_deceleration_modifier
	receiver.boost_factor += stats.boost_factor_modifier
	receiver.mega_boost_factor += stats.mega_boost_factor_modifier
	receiver.boost_generation += stats.boost_generation_modifier
	receiver.boost_per_xp += stats.boost_per_xp_modifier
	receiver.stock_needed_for_boost += stats.stock_needed_for_boost_modifier
	receiver.jump_number += stats.jump_number_modifier
	receiver.max_boost += stats.max_boost_modifier
	receiver.update_orb_magnet_radius(stats.orb_magnet_radius_modifier)
	receiver.gravity += stats.gravity_modifer
	receiver.boost_passive_generation += stats.boost_passive_generation
