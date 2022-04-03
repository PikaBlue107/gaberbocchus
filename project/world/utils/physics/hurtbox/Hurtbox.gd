extends Area2D

class_name Hurtbox

const HitEffectScene = preload("res://world/effects/hit/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
func _on_Timer_timeout():
	self.invincible = false

func create_hit_effect():
	var effect = HitEffectScene.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
#	effect.global_position -= Vector2(0, 8)





func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)
func _on_Hurtbox_invincibility_ended():
	monitoring = true