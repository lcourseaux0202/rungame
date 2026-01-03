class_name Booster extends Button

var card_number : int
var pick_number : int

@onready var label_price: Label = $LabelPrice
@onready var illustration: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func load_booster(data : BoosterData) -> void :
	if data:
		name = data.booster_name
		illustration.texture = data.illustration
		card_number = data.card_number
		pick_number = data.pick_number
		label_price.text = str(data.price)
