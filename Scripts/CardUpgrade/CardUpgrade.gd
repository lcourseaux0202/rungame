class_name CardUpgrade extends Node2D

@onready var card_name: Label = $Pivot/InformationsContainer/CardName
@onready var card_description: Label = $Pivot/InformationsContainer/CardDescription
@onready var price_label: Label = $PriceLabel
@onready var rarity_weight := 0

@onready var card_layout: Sprite2D = $Pivot/CardLayout
@onready var card_illustration: Sprite2D = $Pivot/CardIllustration
@onready var highlight_effect: ColorRect = $Pivot/CardIllustration/HighlightEffect
@onready var animation: AnimationPlayer = $Animation
@onready var purchase_success: AudioStreamPlayer = $PurchaseSuccess
@onready var purchase_failure: AudioStreamPlayer = $PurchaseFailure

var base_speed_modifier := 0
var max_speed_modifier := 0
var acceleration_modifier := 0
var deceleration_modifier := 0
var boost_deceleration_modifier := 0
var rail_deceleration_modifier := 0
var boost_factor_modifier := 0
var mega_boost_factor_modifier := 0
var boost_generation_modifier := 0
var boost_per_xp_modifier := 0.0
var stock_needed_for_boost_modifier := 0
var jump_number_modifier := 0
var max_boost_modifier := 0
var orb_magnet_radius_modifier := 0
var gravity_modifier := 0
var boost_passive_generation := 0

var price := 0

@onready var base_scale := self.scale

var mouse_over = false
var disappearing = false
var clickable = false

signal pressed(card : CardUpgrade)
var tween : Tween

func _ready() -> void:
	highlight_effect.mouse_entered.connect(_highlight_card)
	highlight_effect.mouse_exited.connect(_dehighlight_card)

func make_card_clickable():
	clickable = true

func _highlight_card():
	if not disappearing and clickable:
		mouse_over = true
		var tween := create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", base_scale * 1.2, 0.1)
		animation.play("CardHighlightAnimation")

func _dehighlight_card():
	if not disappearing and clickable:
		mouse_over = false
		var tween := create_tween().set_parallel(true).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "scale", base_scale, 0.1)
		animation.play("RESET")
	
func make_disappear():
	mouse_over = false
	disappearing = true
	animation.play("DisappearAnimation")
	await animation.animation_finished
	queue_free()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Clic") and mouse_over and not disappearing:
		pressed.emit(self)

func load_card(data : CardData, show_price : bool):
	price = (data.price + randi_range(-data.price * 0.1, data.price * 0.1))
	if show_price :
		animation.play("RevealAnimation")
		price_label.text = str(price)
	else :
		animation.play("RevealNoPriceAnimation")
		price = 0
	animation.advance(0)
	clickable = false
	card_name.text = data.card_name
	card_description.text = data.description
	rarity_weight = data.rarity_weight
	
	if data.illustration:
		card_illustration.texture = data.illustration
		
	if rarity_weight >= 13:
		card_layout.modulate = Color.BEIGE
	elif rarity_weight >= 7:
		card_layout.modulate = Color.LIGHT_GREEN
	elif rarity_weight >= 4:
		card_layout.modulate = Color.DODGER_BLUE
	elif rarity_weight >= 2:
		card_layout.modulate = Color.MAGENTA
	else :
		card_layout.modulate = Color.GOLD
	
	base_speed_modifier = data.base_speed_modifier
	max_speed_modifier = data.max_speed_modifier
	acceleration_modifier = data.acceleration_modifier
	deceleration_modifier = data.deceleration_modifier
	boost_deceleration_modifier = data.boost_deceleration_modifier
	rail_deceleration_modifier = data.rail_deceleration_modifier
	boost_factor_modifier = data.boost_factor_modifier
	mega_boost_factor_modifier = data.mega_boost_factor_modifier
	boost_generation_modifier = data.boost_generation_modifier
	boost_per_xp_modifier = data.boost_per_xp_modifier
	stock_needed_for_boost_modifier = data.stock_needed_for_boost_modifier
	jump_number_modifier = data.jump_number_modifier
	max_boost_modifier = data.max_boost_modifier
	orb_magnet_radius_modifier = data.orb_magnet_radius_modifier
	gravity_modifier = data.gravity_modifer
	boost_passive_generation = data.boost_passive_generation
	
	await animation.animation_finished

func can_purchase_card(purchaser : Player) -> bool:
	if purchaser.xp >= price :
		return true
	else :
		animation.stop()
		animation.play("PurchaseImpossibleAnimation")
		purchase_failure.play()
		if tween :
			tween.kill()
		tween = create_tween().set_parallel(true)
		price_label.label_settings.font_color = Color.RED
		tween.tween_property(price_label.label_settings, "font_color", Color.WHITE, 0.4)
		return false

func apply_modifier_on_player(receiver : Player):
	receiver.base_speed += base_speed_modifier
	receiver.max_speed += max_speed_modifier
	receiver.acceleration += acceleration_modifier
	receiver.deceleration += deceleration_modifier
	receiver.boost_deceleration += boost_deceleration_modifier
	receiver.rail_deceleration += rail_deceleration_modifier
	receiver.boost_factor += boost_factor_modifier
	receiver.mega_boost_factor += mega_boost_factor_modifier
	receiver.boost_generation += boost_generation_modifier
	receiver.boost_per_xp += boost_per_xp_modifier
	receiver.stock_needed_for_boost += stock_needed_for_boost_modifier
	receiver.jump_number += jump_number_modifier
	receiver.max_boost += max_boost_modifier
	receiver.update_orb_magnet_radius(orb_magnet_radius_modifier)
	receiver.gravity += gravity_modifier
	receiver.boost_passive_generation += boost_passive_generation
	
	receiver.xp -= price
	
	disappearing = true
	mouse_over = false
	animation.play("BuyCardAnimation")
	purchase_success.play()
	await animation.animation_finished
	await purchase_success.finished
	queue_free()
