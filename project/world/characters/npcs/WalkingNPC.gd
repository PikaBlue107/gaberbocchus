tool
class_name WalkingNPC
extends KinematicBody2D

#--------Exports--------
## Acceleration applied when moving
export(float) var ACCELERATION = 1200 # units movement ^2 per unit real time
## Friction for slowdown
export(float) var FRICTION = 1000 # units movement ^2 per unit real time
## Move speed
export(float) var MAX_SPEED = 15 # units movement per unit real time
## Sprite to use
export(Texture) var texture = null setget set_texture, get_texture

#--------Enums--------
## State machine
enum {
	IDLE,
	MOVE
}

#--------Public variables--------
## Externally controllable field dictating where this NPC moves
var input_vector = Vector2.ZERO
## Direction that the character is facing
var facing = Vector2.DOWN setget set_facing

#--------Private variables--------
## Used to update position every frame
var velocity = Vector2.ZERO # TODO: link to speed of AnimationPlayer via playback_speed; https://godotengine.org/qa/17224/speed-up-slow-down-animation-player
## Current movement state
var state = MOVE

#--------Onready Tree Stuff--------
# ANIMATIONS
onready var animationPlayer = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")

# TODO: restore Stats

#--------Setget--------
func set_texture(value):
	texture = value
	if is_inside_tree():
		$Sprite.texture = texture
func get_texture():
	if is_inside_tree():
		texture = $Sprite.texture
	return texture

## Anytime `facing` updates, also update the animation tree
func set_facing(value):
	facing = value.normalized()
	# if animation tree exists, update the animations too
	if anim_tree != null:
		print("updating blend position")
		anim_tree.set("parameters/Idle/blend_position", facing)
		anim_tree.set("parameters/Run/blend_position", facing)

#--------Virtual Methods--------
## On ready, activate the animation tree
func _ready():
	anim_tree.active = true
	# set animations based on direction
	anim_tree.set("parameters/Idle/blend_position", facing)
	anim_tree.set("parameters/Run/blend_position", facing)

func _physics_process(delta):
	# if in the editor, don't run
	if Engine.editor_hint:
		return
	
	# if some input applied
	if input_vector != Vector2.ZERO:
		# update facing direction
		self.facing = input_vector.normalized()
		# accelerate in direction of movement
		velocity = velocity.move_toward(facing * MAX_SPEED, ACCELERATION * delta)
		# change state to be running
		anim_state.travel("Run")
	# if no input
	else:
		anim_state.travel("Idle")
		decelerate(delta)
#	anim_tree.set("parameters/Idle/blend_position", facing) # TODO: not sure why this is necessary, commenting out to see why
	move()

#--------Private Methods--------

## Slow down velocity and change to "Idle" animation
func decelerate(delta):
	# decelerate
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# start idle animation
	anim_state.travel("Idle")

## Update position based on velocity
func move():
	# move in direction of velocity
	velocity = move_and_slide(velocity)
