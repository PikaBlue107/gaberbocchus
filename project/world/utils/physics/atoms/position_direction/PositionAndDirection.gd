class_name PositionAndDirection
tool
extends Node2D

#--------Exports--------
## Color of the border drawn around the edge of the arrow
export var border_color : Color = Color.black
## Color of the interior of the arrow
export var inner_color : Color = Color.white
## Length of the shaft of the arrow (not including the tip)
export(float, 0, 40) var body_length : float = 3 setget set_distance
## Width of the shaft of the arrow
export(float, 0, 10) var body_width : float = 1.5 setget set_body_width
## Length of the tip of the arrow
export(float, 0, 20) var head_len : float = 2 setget set_head_len
## Width of the tip of the arrow
export(float, 0, 20) var head_width : float = 3 setget set_head_width
## Thickness of the border drawn around the edge of the arrow
export(float, 0, 1) var border_thickness : float = 0.2 setget set_border_thickness

# anytime these are updated, trigger a redraw
func set_distance(value):
	body_length = value
	update()
func set_body_width(value):
	body_width = value
	update()
func set_head_len(value):
	head_len = value
	update()
func set_head_width(value):
	head_width = value
	update()
func set_border_thickness(value):
	border_thickness = value
	update()

## Get the direction described as a vector
func dir_as_vector():
	return Vector2.UP.rotated(rotation)

## Draw an arrow in this node's UP direction, after rotation
## Only draws in the editor
func _draw():
	# if not in editor, skip
	if not Engine.editor_hint:
		return
	
	# precompute some data
	var vector = Vector2.RIGHT * body_length
	var h2w2 = sqrt(head_len*head_len + (head_width / 2)*(head_width / 2))
	var inner_head_len = get_inner_head_len(
			border_thickness, head_width / 2, head_len, h2w2)
	var inner_head_halfwidth = get_inner_head_halfwidth(
			border_thickness, head_width / 2, head_len, h2w2)
	
	# draw black border
	draw_line(Vector2.ZERO, vector, border_color, body_width)
	draw_colored_polygon(PoolVector2Array([
				vector + Vector2(head_len, 0),
				vector + Vector2(0, -head_width / 2),
				vector + Vector2(0, head_width / 2)
			]), border_color)
	
	# draw inner white arrow
	draw_line(
			Vector2(border_thickness, 0),
			Vector2(border_thickness, 0) + vector,
			inner_color, body_width - 2 * border_thickness)
	draw_colored_polygon(PoolVector2Array([
				vector + Vector2(inner_head_len, 0),
				vector + Vector2(border_thickness, -inner_head_halfwidth),
				vector + Vector2(border_thickness, inner_head_halfwidth)
			]), inner_color)
			
## calculate exact position w/ a trig formula I worked out
## for the right side of the triangle, i.e. positive y
## https://www.desmos.com/calculator/0hyi3rz4xu
func get_inner_head_halfwidth(b, w, h, h2w2):
	return w - b*(w/h + h/h2w2 + w*w/(h*h2w2))

## calculate exact position w/ a trig formula I worked out
## https://www.desmos.com/calculator/0hyi3rz4xu
func get_inner_head_len(b, w, h, h2w2):
	return h - b*(w/h2w2 + h*h/(w*h2w2))

