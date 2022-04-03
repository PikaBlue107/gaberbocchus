tool
extends Node2D


func _draw():
	if Engine.editor_hint:
		var left = Vector2(-24, 0)
		var right = Vector2(24, 0)
		var color = Color.lightgreen
		color.a = 0.3
		draw_circle(left, 3, color)
		draw_circle(right, 3, color)
		draw_line(left, right, color, 2)

