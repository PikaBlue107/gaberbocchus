tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim_sprite = $AnimatedSprite
onready var anim_player = $AnimationPlayer

# Allow editor to control which SpriteFrames is used
export(SpriteFrames) var sprite_frames setget set_sprite_frames
# Allow user to control the speed and start position of the animation
export(float) var anim_speed = 1 setget set_anim_speed
export(float) var anim_start = 0 setget set_anim_start

func set_anim_start(value):
	anim_start = value
	if is_inside_tree():
		$AnimationPlayer.advance(anim_start)
func set_anim_speed(value):
	anim_speed = value
	if is_inside_tree():
		$AnimationPlayer.set_speed_scale(anim_speed)
func set_sprite_frames(value):
	sprite_frames = value
	if is_inside_tree() && sprite_frames != null:
		$AnimatedSprite.frames = sprite_frames
		


# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite_frames != null:
		anim_sprite.frames = sprite_frames
	anim_player.advance(anim_start)
	anim_player.set_speed_scale(anim_speed)


