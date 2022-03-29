extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim_sprite = $AnimatedSprite
onready var anim_player = $AnimationPlayer

# Allow editor to control which SpriteFrames is used
export(SpriteFrames) var spriteFrames
# Allow user to control the speed and start position of the animation
export(float) var anim_speed = 1
export(float) var anim_start = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	if spriteFrames != null:
		anim_sprite.frames = spriteFrames
	anim_player.advance(anim_start)
	anim_player.set_speed_scale(anim_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
