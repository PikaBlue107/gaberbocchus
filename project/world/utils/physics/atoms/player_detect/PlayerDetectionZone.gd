class_name PlayerDetectionZone
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


#--------Public Fields--------
## Tracks the player currently inside of this zone
var player = null



#--------Setget Functions--------
		
# Link our exported CollisionShape to the one for the CollisionShape2D
func set_collision_shape(value: Shape2D):
	collision_shape = value
	if is_inside_tree():
		$CollisionShape2D.shape = collision_shape
func get_collision_shape() -> Shape2D:
	if is_inside_tree():
		collision_shape = $CollisionShape2D.shape
	return collision_shape


#--------Event Handlers--------

## When this script is ready, update the CollisionShape2D with ours.
func _ready():
	$CollisionShape2D.shape = collision_shape
	
## When player enters our area, save a reference to them and signal up.
func _on_PlayerDetectionZone_body_entered(body):
	# check that the body is a player
	if not _is_body_player(body):
		return
	# proceed
	player = body
	emit_signal("player_entered")

## When player exits out area, clear the reference and signal up.
func _on_PlayerDetectionZone_body_exited(body):
	if not _is_body_player(body):
		return
	# proceed
	player = body
	emit_signal("player_exited")
	
#--------Private Helpers--------

## Detect if a Node is the Player we're trying to find
func _is_body_player(body: Node) -> bool:
	return body is Player
