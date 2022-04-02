extends Node

# Health
export(int)  var max_health = 1 setget set_max_health
var health = max_health setget set_health


signal no_health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	self.health = max_health

func take_damage(dmg):
	self.health -= dmg


func set_health(value):
	health = value
	emit_signal("health_changed", value)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	 # if max health set to lower than health, drop health down to match
	self.health = min(health, max_health)
	emit_signal("max_health_changed", value)
