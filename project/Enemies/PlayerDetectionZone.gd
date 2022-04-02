extends Area2D

# our own signals to ensure that we set player first
## Player entered the area, and is accessible via player field
signal player_entered
## Player exited the area
signal player_exited

## Tracks the player currently inside of this zone
var player = null

## When player enters our area, save a reference to them and signal up.
func _on_PlayerDetectionZone_body_entered(body):
	player = body
	emit_signal("player_entered")

## When player exits out area, clear the reference and signal up.
func _on_PlayerDetectionZone_body_exited(body):
	player = null
	emit_signal("player_exited")
