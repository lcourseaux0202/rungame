@tool
extends Control

var color1 : Color = Color.WHITE
var color2 : Color = Color.BLACK

func _draw() -> void:
	var points1 = PackedVector2Array([
		Vector2.ZERO,
		Vector2(size.x, 0),
		Vector2(0, size.y)
	])
	
	var points2 = PackedVector2Array([
		Vector2(size.x, 0),
		Vector2(size.x, size.y),
		Vector2(0, size.y)
	])
	
	draw_polygon(points1, PackedColorArray([color1]))
	draw_polygon(points2, PackedColorArray([color2]))
