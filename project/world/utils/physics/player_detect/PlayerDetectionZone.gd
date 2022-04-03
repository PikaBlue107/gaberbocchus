tool
extends Area2D


#--------Signals--------
# our own signals to ensure that we set player first
## Player entered the area, and is accessible via player field
signal player_entered
## Player exited the area
signal player_exited


#--------Exports--------
export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape
export var damage = 1


#--------Public Fields--------
## Tracks the player currently inside of this zone
var player = null



#--------Setget Functions--------
		
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


#--------Event Handlers--------
## When player enters our area, save a reference to them and signal up.
func _on_PlayerDetectionZone_body_entered(body):
	player = body
	emit_signal("player_entered")

## When player exits out area, clear the reference and signal up.
func _on_PlayerDetectionZone_body_exited(body):
	player = null
	emit_signal("player_exited")
