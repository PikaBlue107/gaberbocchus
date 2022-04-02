tool
extends Area2D

export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape

# Link our exported CollisionShape to the one for the CollisionShape2D
func set_collision_shape(value: Shape2D):
	collision_shape = value
	if not is_inside_tree():
		yield(self, 'ready')
	$CollisionShape2D.shape = collision_shape
func get_collision_shape() -> Shape2D:
	if is_inside_tree():
		collision_shape = $CollisionShape2D.shape
	return collision_shape
	
	

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0] # get first area that we're colliding with
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalize()
	return push_vector
