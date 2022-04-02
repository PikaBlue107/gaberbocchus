extends Node2D

# Signals

signal segment_finish

# Exports

export(float) var wander_range = 32
export(NodePath) onready var moving_body = \
		get_node(moving_body) as PhysicsBody2D

# Onready

onready var start_position = global_position
#Nodes
onready var target_position = $Node/TargetPosition \
		setget set_target_position, get_target_position
onready var timer = $Timer



# setget for target position

## Set target_position on the inner TargetPosition node
func set_target_position(value: Vector2):
	target_position.global_position = value

## Get target_position from the inner TargetPosition node
func get_target_position() -> Vector2:
	return target_position.global_position


## Pick a new target position
func update_target_position():
	# TODO: optimize - don't pick an inaccessible target_vector
	var target_vector = Vector2(
			rand_range(-wander_range, wander_range),
			rand_range(-wander_range, wander_range))
	self.target_position = start_position + target_vector


## Begin the next wander segment
func start_wander_segment():
	update_target_position()
	timer.start(rand_range(1, 3))
	
## Cancel the current segment
func cancel_segment():
	timer.stop()
	self.target_position = Vector2(INF, INF)
	


## end this wander segment by emitting a signal and picking the next target
func _end_segment():
	emit_signal("segment_finish")
	
## whenever the timer runs out, end this segment
func _on_Timer_timeout():
	_end_segment()
	
## whenever we reach the target, end this segment
func _on_TargetPosition_body_entered(body):
	if body == moving_body:
		cancel_segment()
		_end_segment()
