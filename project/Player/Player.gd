extends KinematicBody2D


# Acceleration applied when moving
const ACCELERATION = 1200 # units movement ^2 per unit real time
# Friction for slowdown
const FRICTION = 900 # units movement ^2 per unit real time
# Move speed
const MAX_SPEED = 80 # units movement per unit real time
# Roll speed
const ROLL_SPEED = MAX_SPEED * 1.5
# Used to update position every frame
var velocity = Vector2.ZERO
# remember direction we're facing
var facing = Vector2.LEFT

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE



# ANIMATIONS
# player
onready var animationPlayer = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

func _ready():
	anim_tree.active = true



func _physics_process(delta):
	# Update state machine
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)
			


func move_state(delta):
	
	# Gather normalized input vector
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# if some input applied
	if input_vector != Vector2.ZERO:
		facing = input_vector
		# accelerate in direction of movement
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		# play animation to move
		# set blend position based on direction
		anim_tree.set("parameters/Idle/blend_position", input_vector)
		anim_tree.set("parameters/Run/blend_position", input_vector)
		anim_tree.set("parameters/Attack/blend_position", input_vector)
		anim_tree.set("parameters/Roll/blend_position", input_vector)
		# change state to be running
		anim_state.travel("Run")
	# if no input
	else:
		# decelerate
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		# idle animation
		anim_state.travel("Idle")

		
	move()
	
	
	# Handle state changes
#	if Input.is_action_just_pressed("attack"):
#		state = ATTACK
#	elif Input.is_action_just_pressed("roll"):
#		state = ROLL

func roll_state(delta):
	velocity = facing * ROLL_SPEED
	anim_state.travel("Roll")
	move()


func attack_state(delta):
	velocity = Vector2.ZERO
	anim_state.travel("Attack")
	
func move():
	# move in direction of velocity
	velocity = move_and_slide(velocity)
	
	
func roll_anim_finish():
	state = MOVE
	
func attack_state_end():
	state = MOVE
#	anim_state.travel("Move") # workaround - this should happen on its own, but w/e


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
