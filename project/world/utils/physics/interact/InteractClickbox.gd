tool
extends StaticBody2D

#--------Exports--------
export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape
export var oneshot = true
export(String, FILE, "*.json") var json_path setget set_json_path, get_json_path



#--------Variables--------
var completions = 0

#--------Nodes--------
onready var InteractDialogue = $CanvasLayer/InteractDialogue


#--------Resources--------
onready var InteractCursorTexture = \
		preload("res://ui/interact/interact_cursor.png")


#--------Virtual Functions--------

func _ready():
	$ClickableArea.shape = collision_shape
	InteractDialogue.visible = false
	InteractDialogue.json_path = json_path
	
#--------Setget Functions--------

func set_json_path(value: String) -> void:
	json_path = value
	if is_inside_tree() and json_path != null:
		$CanvasLayer/InteractDialogue.json_path = json_path

func get_json_path() -> String:
	if is_inside_tree():
		json_path = $CanvasLayer/InteractDialogue.json_path
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

#--------Event Handlers--------

## When player interacts with clickbox, start dialogue
## as long as this isn't a finished oneshot
func _on_InteractClickbox_input_event(viewport, event, shape_idx):
	# if interact event received, launch dialogue
	if event.is_action_pressed("interact"):
		
		# if oneshot and we've already run it, don't start it again
		if oneshot and completions > 0:
			return
		
		# launch dialogue
		InteractDialogue.visible = true
		InteractDialogue.restart()


## When dialogue finishes, mark it invisible and update our completion count
func _on_InteractDialogue_dialogue_complete():
	completions += 1
	InteractDialogue.visible = false


func _on_InteractClickbox_mouse_entered():
	Input.set_custom_mouse_cursor(InteractCursorTexture)
#	pass


func _on_InteractClickbox_mouse_exited():
	Input.set_custom_mouse_cursor(null)
