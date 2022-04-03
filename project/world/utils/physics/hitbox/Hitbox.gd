tool
extends Area2D
class_name Hitbox


#--------Exports--------
export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape
export var damage = 1
export(bool) var disabled = false setget set_disabled, get_disabled

#--------Setget Functions--------
		
# Link our exported CollisionShape to the one for the CollisionShape2D
func set_collision_shape(value: Shape2D):
	print("set_collision_shape(%s)" % str(value))
	collision_shape = value
	if not is_inside_tree():
		print("waiting to set_collision_shape until in tree...")
		yield(self, 'ready')
	print("in tree, setting collision_shape now...")
	$CollisionShape2D.shape = collision_shape
func get_collision_shape() -> Shape2D:
	if is_inside_tree():
		collision_shape = $CollisionShape2D.shape
	return collision_shape

func set_disabled(value: bool) -> void:
	print("set_disabled(%s)" % str(value))
	disabled = value
	if not is_inside_tree():
		print("waiting to set_disabled until in tree...")
		yield(self, 'ready')
	print("in tree, setting disabled now...")
	$CollisionShape2D.disabled = disabled
func get_disabled() -> bool:
	if is_inside_tree():
		disabled = $CollisionShape2D.disabled
	return disabled
