tool
extends StaticBody2D

#--------Exports--------
export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape
export(String, FILE, "*.json") var json_path setget set_json_path, get_json_path
export(bool) var oneshot setget set_oneshot, get_oneshot
export(bool) var midway_restartable setget set_midway_restartable, get_midway_restartable


#--------Nodes--------
onready var InteractDialogueControl = $CanvasLayer/InteractDialogueControl


#--------Resources--------
onready var InteractCursorTexture = \
		preload("res://ui/interact/interact_cursor.png")


#--------Virtual Functions--------

func _ready():
	$ClickableArea.shape = collision_shape
	InteractDialogueControl.visible = false
	InteractDialogueControl.json_path = json_path
#	print("InteractClickbox ready!")
	
#--------Setget Functions--------

func set_json_path(value: String) -> void:
	json_path = value
	if is_inside_tree() and json_path != null:
		$CanvasLayer/InteractDialogueControl.json_path = json_path
func get_json_path() -> String:
	if is_inside_tree():
		json_path = $CanvasLayer/InteractDialogueControl.json_path
	return json_path
		
# Link our exported CollisionShape to the one for the CollisionShape2D
func set_collision_shape(value: Shape2D):
	collision_shape = value
#	if not is_inside_tree():
#		print("waiting to set_collision_shape until in tree...")
#		yield(self, 'ready')
#	print("in tree, setting collision_shape now...")
#	$CollisionShape2D.shape = collision_shape
	if is_inside_tree():
		$ClickableArea.shape = collision_shape
func get_collision_shape() -> Shape2D:
	if is_inside_tree():
		collision_shape = $ClickableArea.shape
	return collision_shape

func set_oneshot(value: bool):
	oneshot = value
	if is_inside_tree():
		$CanvasLayer/InteractDialogueControl.oneshot = value
func get_oneshot() -> bool:
	if is_inside_tree():
		oneshot = $CanvasLayer/InteractDialogueControl.oneshot
	return oneshot
	
func set_midway_restartable(value: bool):
	midway_restartable = value
	if is_inside_tree():
		$CanvasLayer/InteractDialogueControl.midway_restartable = value
func get_midway_restartable() -> bool:
	if is_inside_tree():
		midway_restartable = $CanvasLayer/InteractDialogueControl.midway_restartable
	return midway_restartable

#--------Event Handlers--------

## When player interacts with clickbox, start dialogue
## as long as this isn't a finished oneshot
func _on_InteractClickbox_input_event(_viewport, event, _shape_idx):
	# if interact event received, launch dialogue
	if event.is_action_pressed("interact"):
		Input.set_custom_mouse_cursor(null)
		InteractDialogueControl.try_begin_dialogue()


func _on_InteractClickbox_mouse_entered():
	# if already completed and not oneshot, don' show cursor
	if $CanvasLayer/InteractDialogueControl.completions > 0 and oneshot:
		return
	# if midway and not midway_restartable, don't show cursor
	if $CanvasLayer/InteractDialogueControl.visible and not midway_restartable:
		return
	Input.set_custom_mouse_cursor(InteractCursorTexture)


func _on_InteractClickbox_mouse_exited():
	# TODO: bug - if mouse is under another clickbox, skip this
	Input.set_custom_mouse_cursor(null)
