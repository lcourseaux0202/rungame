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

var stats : CardData

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
	stats = data
	if show_price :
		animation.play("RevealAnimation")
		price_label.text = str(data.price)
	else :
		animation.play("RevealNoPriceAnimation")
	animation.advance(0)
	clickable = false
	card_name.text = data.card_name
	card_description.text = data.description
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
			
	card_layout.modulate = color

	await animation.animation_finished

func can_purchase_card(purchaser : Player) -> bool:
	if purchaser.xp >= stats.price :
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
	receiver.base_speed += stats.base_speed_modifier
	receiver.max_speed += stats.max_speed_modifier
	receiver.acceleration += stats.acceleration_modifier
	receiver.deceleration += stats.deceleration_modifier
	receiver.boost_deceleration += stats.boost_deceleration_modifier
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
	
	receiver.xp -= stats.price
	
	disappearing = true
	mouse_over = false
	animation.play("BuyCardAnimation")
	purchase_success.play()
	await animation.animation_finished
	await purchase_success.finished
	queue_free()
