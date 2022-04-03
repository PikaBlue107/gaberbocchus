tool
extends Area2D

class_name Hurtbox

#--------Signals--------
## Emitted when invincibility begins
signal invincibility_started
## Emitted when invincibility ends
signal invincibility_ended

#--------Exports--------
export(Shape2D) var collision_shape setget set_collision_shape, get_collision_shape


#--------Resources--------
## Hit effect to play when hit
const HitEffectScene = preload("res://world/effects/hit/HitEffect.tscn")


#--------Nodes--------
## Invincibility timer
onready var timer = $Timer



#--------Public variables--------
## Whether or not this hurtbox is currently invincible
var invincible = false setget set_invincible



#--------Setget Functions--------

## Set invincible true or false, emitting the appropriate event
## and enabling/disabling the hitbox
func set_invincible(value: bool) -> void:
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
# Link our exported CollisionShape to the one for the CollisionShape2D
func set_collision_shape(value: Shape2D):
	collision_shape = value
	if not is_inside_tree():
		yield(self, 'ready')
	$CollisionShape2D.shape = collision_shape
func get_collision_shape() -> Shape2D:
	if is_inside_tree():
		collision_shape = $CollisionShape2D.shape
	return collision_shape
		
#---------Public Functions--------
		
## Begin invincibility for the specified duration
func start_invincibility(duration: float) -> void:
	self.invincible = true
	timer.start(duration)

## Create a hit effect on this hitbox
func create_hit_effect() -> void:
	var effect = HitEffectScene.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
#	effect.global_position -= Vector2(0, 8)



#--------Event Handlers--------

## When the timer runs out, disable invincibility
func _on_Timer_timeout():
	self.invincible = false # trigger setget

# TODO: move these two into the set_invincible setter?
## When invincibility starts, disable the hitbox
func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)# TODO: use disabled?
## When invincibility ends, enable the hitbox
func _on_Hurtbox_invincibility_ended():
	monitoring = true
