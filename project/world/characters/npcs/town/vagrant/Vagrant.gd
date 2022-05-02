tool
extends WalkingNPC

var move_right = true

onready var timer : Timer = $Timer

func _ready():
	input_vector = Vector2.RIGHT
	timer.start()


func _on_Timer_timeout():
	# Change state
	if state == MOVE:
		move_right = not move_right
		state = IDLE
		facing = Vector2.DOWN
		anim_tree.set("parameters/Idle/blend_position", facing)
	else:
		state = MOVE
		input_vector = Vector2.RIGHT if move_right else Vector2.LEFT
