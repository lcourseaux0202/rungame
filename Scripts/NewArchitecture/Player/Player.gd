class_name Player extends CharacterBody2D

@export var speed := 500.0
@export var gravity := 4000.0
@export var jump_impulse := 1800.0
@export_range(1,10) var jump_number := 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
