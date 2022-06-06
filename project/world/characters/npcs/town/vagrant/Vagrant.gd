tool
extends WalkingNPC

var move_right = true

onready var timer : Timer = $Timer

func _ready():
	input_vector = Vector2.RIGHT
	timer.start()


func _on_Timer_timeout():
	# Change state
	if input_vector:
		input_vector = Vector2.ZERO # stop moving
		self.facing = Vector2.DOWN # face forwards, trigger setget
	else:
		move_right = not move_right
		input_vector = Vector2.RIGHT if move_right else Vector2.LEFT
