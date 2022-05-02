tool
extends InputDetectionZone

export var scene_name : String = "dock"

onready var InteractCursorTexture = \
		preload("res://ui/interact/cursor_go.png")

## When the player interacts, switch scenes
func _on_InteractSceneChange_event_occurred():
	var World = get_node("/root/GameWorld") # as GameWorld # causes circular dependency
	World.change_scene(scene_name)

# "Enter Scene" cursor
## When the mouse hovers over this area, set cursor to "Enter Scene"
func _on_InteractSceneChange_mouse_entered():
	Input.set_custom_mouse_cursor(InteractCursorTexture)
## When the mouse leaves this area, set cursor to default
func _on_InteractSceneChange_mouse_exited():
	Input.set_custom_mouse_cursor(null)
