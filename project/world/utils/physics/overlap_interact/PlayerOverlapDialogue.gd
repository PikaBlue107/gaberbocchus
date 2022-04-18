tool
extends PlayerDetectionZone

#--------Exports--------

export(String, FILE, "*.json") var json_path setget set_json_path, get_json_path
export(bool) var oneshot setget set_oneshot, get_oneshot
export(bool) var midway_restartable setget set_midway_restartable, get_midway_restartable


#--------Nodes--------
onready var InteractDialogueControl = $CanvasLayer/InteractDialogueControl



#--------Virtual Functions--------

func _ready():
	InteractDialogueControl.visible = false
	InteractDialogueControl.json_path = json_path
	print("PlayerOverlapDialogue ready!")
	
#--------Setget Functions--------

func set_json_path(value: String) -> void:
	json_path = value
	if is_inside_tree() and json_path != null:
		$CanvasLayer/InteractDialogueControl.json_path = json_path
func get_json_path() -> String:
	if is_inside_tree():
		json_path = $CanvasLayer/InteractDialogueControl.json_path
	return json_path
	
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
func _on_PlayerOverlapDialogue_player_entered():
	# Try to launch the dialogue
	InteractDialogueControl.try_begin_dialogue()
