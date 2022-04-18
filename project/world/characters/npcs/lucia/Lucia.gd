class_name Lucia
extends KinematicBody2D

# This is the means of an external class controlling the character
# Set this towards where you want to go
var input_vector = Vector2.ZERO
# Acceleration applied when moving
export(float) var ACCELERATION = 1200 # units movement ^2 per unit real time
# Friction for slowdown
export(float) var FRICTION = 1000 # units movement ^2 per unit real time
# Move speed
export(float) var MAX_SPEED = 60 # units movement per unit real time
# Roll speed
export(float) var ROLL_SPEED = MAX_SPEED * 1.5
# Used to update position every frame
var velocity = Vector2.ZERO
# remember direction we're facing
var facing = Vector2.DOWN

# State machine

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

onready var hurtbox = $Hurtbox

# Stats

var stats = PlayerStats

func _ready():
	anim_tree.active = true
	stats.connect("no_health", self, "queue_free")



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
	
	# if some input applied
	if input_vector != Vector2.ZERO:
		facing = input_vector.normalized()
		# accelerate in direction of movement
		velocity = velocity.move_toward(input_vector.normalized() * MAX_SPEED, ACCELERATION * delta)
		# play animation to move
		# set blend position based on direction
		anim_tree.set("parameters/Idle/blend_position", facing)
		anim_tree.set("parameters/Run/blend_position", facing)
		anim_tree.set("parameters/Attack/blend_position", facing)
		anim_tree.set("parameters/Roll/blend_position", facing)
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

	
func move():
	# move in direction of velocity
	velocity = move_and_slide(velocity)
	

func _on_Hurtbox_area_entered(area):
	if !hurtbox.invincible:
		stats.health -= area.damage
		hurtbox.start_invincibility(0.5)
		hurtbox.create_hit_effect()

# UNUSED
func roll_anim_finish():
	state = MOVE
	
func attack_state_end():
	state = MOVE
#	anim_state.travel("Move") # workaround - this should happen on its own, but w/e

func roll_state(delta):
	velocity = facing * ROLL_SPEED
	anim_state.travel("Roll")
	move()

func attack_state(delta):
	velocity = Vector2.ZERO
	anim_state.travel("Attack")
