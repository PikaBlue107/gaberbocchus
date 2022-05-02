tool
class_name WalkingNPC
extends KinematicBody2D

# This is the means of an external class controlling the character
# Set this towards where you want to go
var input_vector = Vector2.ZERO
# Acceleration applied when moving
export(float) var ACCELERATION = 1200 # units movement ^2 per unit real time
# Friction for slowdown
export(float) var FRICTION = 1000 # units movement ^2 per unit real time
# Move speed
export(float) var MAX_SPEED = 15 # units movement per unit real time
# Sprite to use
export(Texture) var texture = null setget set_texture, get_texture
# Used to update position every frame
var velocity = Vector2.ZERO
# remember direction we're facing
var facing = Vector2.DOWN

# State machine

enum {
	IDLE,
	MOVE
}

var state = MOVE


# ANIMATIONS
# player
onready var animationPlayer = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

# Stats

var stats = PlayerStats

func _ready():
	anim_tree.active = true
	
func set_texture(value):
	texture = value
	if is_inside_tree():
		$Sprite.texture = texture
func get_texture():
	if is_inside_tree():
		texture = $Sprite.texture
	return texture



func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	# Update state machine
	match state:
		MOVE:
			move_state(delta)
		IDLE:
			idle_state(delta)
			


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
	anim_tree.set("parameters/Idle/blend_position", facing)
	move()

func idle_state(delta):
	# decelerate
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# idle animation
	anim_state.travel("Idle")
	move()
	
	
func move():
	# move in direction of velocity
	velocity = move_and_slide(velocity)
