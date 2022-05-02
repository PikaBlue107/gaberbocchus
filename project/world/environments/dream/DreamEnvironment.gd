extends Node2D

var dialogue_step = 0

func _ready():
	# Sit and wait for a bit
	$DreamPlayer.input_vector = Vector2.ZERO
	yield(get_tree().create_timer(1.2), "timeout")
	
	# Step forward
	$DreamPlayer.input_vector = Vector2.DOWN
	yield(get_tree().create_timer(0.5), "timeout")
	
	# Sit for another while
	$DreamPlayer.input_vector = Vector2.ZERO
	yield(get_tree().create_timer(2.0), "timeout")
	
	# Look around
	$DreamPlayer.facing = Vector2.RIGHT
	yield(get_tree().create_timer(0.6), "timeout")
	$DreamPlayer.facing = Vector2.DOWN
	yield(get_tree().create_timer(0.6), "timeout")
	$DreamPlayer.facing = Vector2.LEFT
	yield(get_tree().create_timer(0.6), "timeout")
	$DreamPlayer.facing = Vector2.DOWN
	yield(get_tree().create_timer(1.4), "timeout")
	
	# Face right
	$DreamPlayer.facing = Vector2.RIGHT
	yield(get_tree().create_timer(2.1), "timeout")
	
	# Long walk down the hallway
	$DreamPlayer.input_vector = Vector2.RIGHT
	# slowly speed up
	while $DreamPlayer.MAX_SPEED < 30:
		$DreamPlayer.MAX_SPEED += 1.5
		yield(get_tree().create_timer(1.0), "timeout")
	# continue once they reach the target

func _on_TargetDetectionZone_target_entered():
	
	# trigger dialogue
	$CanvasLayer/InteractDialogueControl.try_begin_dialogue()
	
	# walk for a moment more, then stop
	yield(get_tree().create_timer(0.3), "timeout")
	$DreamPlayer.input_vector = Vector2.ZERO

	
	# when it's done, we'll handle the rest
	
func _on_InteractDialogueControl_dialogue_advance():
	dialogue_step += 1
#	print("dialogue advanced, up to " + str(dialogue_step))
	# if this is the 2nd dialogue advancement
	if dialogue_step == 3: # don't ask why it's 3, just trust me
		#wait and then face the spirit
		yield(get_tree().create_timer(0.5), "timeout")
		$DreamPlayer.facing = Vector2.UP


func _on_InteractDialogueControl_dialogue_complete():
	
	# pause for a couple seconds
	$DreamPlayer.input_vector = Vector2.ZERO
	yield(get_tree().create_timer(2.0), "timeout")
	
	
	# switch scenes with a slow fadeout
	var World = get_node("/root/GameWorld") # as GameWorld # causes circular dependency
	World.change_scene("dock", 5.0, 3.0) # TODO: replace with forest

