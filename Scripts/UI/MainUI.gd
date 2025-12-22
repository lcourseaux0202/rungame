extends Control
class_name MainUI

@onready var boost_bar: ProgressBar = $BoostBar

func _ready() -> void:
	EventBus.boost_value_changed.connect(_update_boost_bar)

func _update_boost_bar(boost_value : float):
	boost_bar.value = clamp(boost_value, boost_bar.min_value, boost_bar.max_value)
