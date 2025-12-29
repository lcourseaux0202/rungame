class_name SoloGameUI extends Control

@onready var timer_label: Label = $TimerLabel
@onready var timer: Timer = $Timer

signal game_over

func _ready() -> void:
	visible = (Settings.gamemode == Settings.GAMEMODE.SOLO)
	timer.timeout.connect(func():game_over.emit())

func start_timer(game_duration):
	timer.start(game_duration)
	show()
	
func stop_timer():
	timer.stop()
	hide()

func _process(delta: float) -> void:
	timer_label.text = str(int(timer.time_left))
