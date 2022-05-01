extends InteractDialogue

#--------Exports--------
export var oneshot = true
export var midway_restartable = false


#--------Variables--------
var completions = 0


#--------Virtual Functions--------

func _ready():
	visible = false
	
#--------Public Functions--------

func try_begin_dialogue():
	# if oneshot and we've already run it, don't start it again
	if oneshot and completions > 0:
		return
	# if we're midway and not able to restart midway, don't restart
	if visible and not midway_restartable:
		return
	
	# pause scene tree
#	print("tree paused!")
	get_tree().paused = true
	# launch dialogue
	visible = true
	restart()



#--------Event Handlers--------

## When dialogue finishes, mark it invisible and update our completion count
func _on_InteractDialogueControl_dialogue_complete():
	completions += 1
	visible = false
	# resume scene tree
	# defer the call so that we don't trigger another dialogue
	call_deferred("_unpause") 
func _unpause():
	get_tree().paused = false
