tool
extends Area2D

#--------Exports--------
export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape
export(Array, String, FILE, "*.json") var json_path_arr setget set_json_path_arr

#--------Private Variables--------
var dialogue_idx = 0


#--------Nodes--------
onready var InteractDialogueControl = $CanvasLayer/InteractDialogueControl


#--------Resources--------
onready var InteractCursorTexture = \
		preload("res://ui/interact/interact_cursor.png")


#--------Virtual Functions--------

func _ready():
	$ClickableArea.shape = collision_shape
	InteractDialogueControl.visible = false
	InteractDialogueControl.json_path = json_path_arr[0]
	# hardcode stuff to make it work
	InteractDialogueControl.oneshot = true
	InteractDialogueControl.midway_restartable = false
	
#--------Setget Functions--------

func set_json_path_arr(value: Array) -> void:
	json_path_arr = value
	if is_inside_tree() and json_path_arr != null and json_path_arr[0] != null:
		$CanvasLayer/InteractDialogueControl.json_path = json_path_arr[0]
		
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

## When player interacts with clickbox, start dialogue
## as long as this isn't a finished oneshot
func _on_InteractClickbox_input_event(_viewport, event, _shape_idx):
	# if interact event received, launch dialogue
	if event.is_action_pressed("interact"):
		Input.set_custom_mouse_cursor(null)
		InteractDialogueControl.try_begin_dialogue()


func _on_InteractClickbox_mouse_entered():
	# if midway, don't show cursor
	if $CanvasLayer/InteractDialogueControl.visible:
		return
	# if already completed, don' show cursor
	if $CanvasLayer/InteractDialogueControl.completions > 0 and dialogue_idx == json_path_arr.size():
		return
	Input.set_custom_mouse_cursor(InteractCursorTexture)


func _on_InteractClickbox_mouse_exited():
	# TODO: bug - if mouse is under another clickbox, skip this
	Input.set_custom_mouse_cursor(null)


func _on_InteractDialogueControl_dialogue_complete():
	# hopefully this runs after InteractDialogueControl increments that field...
	call_deferred("_set_next_dialogue")
func _set_next_dialogue():
	# Move on to the next dialogue
	dialogue_idx += 1
	# If there's no more dialogue, exit
	if dialogue_idx == json_path_arr.size():
		return
	
	# Reset the dialogue control to the next dialogue
	InteractDialogueControl.completions = 0
	InteractDialogueControl.json_path = json_path_arr[dialogue_idx]
	
