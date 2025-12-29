class_name CardData extends Resource

enum RARITY{
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

@export var card_name: String = "Card name"
@export_multiline var description: String = ""
@export var illustration: Texture2D
@export var rarity: RARITY = RARITY.COMMON

@export var base_speed_modifier := 0
@export var max_speed_modifier := 0
@export var acceleration_modifier := 0
@export var deceleration_modifier := 0
@export var boost_deceleration_modifier := 0
@export var rail_deceleration_modifier := 0
@export var boost_factor_modifier := 0.0
@export var mega_boost_factor_modifier := 0.0
@export var boost_generation_modifier := 0
@export var boost_per_xp_modifier := 0.0
@export var stock_needed_for_boost_modifier := 0
@export var jump_number_modifier := 0
@export var max_boost_modifier := 0
@export var orb_magnet_radius_modifier := 0
@export var gravity_modifer := 0
@export var boost_passive_generation := 0

@export var price := 150

func get_rarity_weight() -> int:
	var rarity_weight = 0
	match rarity :
		CardData.RARITY.COMMON :
			rarity_weight = 27
		CardData.RARITY.UNCOMMON :
			rarity_weight = 12
		CardData.RARITY.RARE :
			rarity_weight = 5
		CardData.RARITY.EPIC :
			rarity_weight = 1
		CardData.RARITY.LEGENDARY :
			rarity_weight = 0
			
	return rarity_weight
