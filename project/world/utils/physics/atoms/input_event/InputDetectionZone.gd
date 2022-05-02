class_name InputDetectionZone
tool
extends Area2D

#--------Signals--------
signal event_occurred

#--------Exports--------
export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape
export(String) var target_event = "interact"

#--------Virtual Functions--------

func _ready():
	$ClickableArea.shape = collision_shape
	
#--------Setget Functions--------
		
# Link our exported CollisionShape to the one for the CollisionShape2D
func set_collision_shape(value: Shape2D):
	collision_shape = value
	if is_inside_tree():
		$ClickableArea.shape = collision_shape
func get_collision_shape() -> Shape2D:
	if is_inside_tree():
		collision_shape = $ClickableArea.shape
	return collision_shape

#--------Event Handlers--------

## When player interacts with clickable area, signal up
func _on_InputDetectionZone_input_event(_viewport, event, _shape_idx):
	# if interact event received, signal up
	if event.is_action_pressed(target_event):
		emit_signal("event_occurred")
