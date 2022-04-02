extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# load the GrassEffectScene we'll use to perish ourselves
#onready var GrassEffectScene = load("res://Effects/GrassEffect.tscn")

const GrassEffectScene = preload("res://Effects/GrassEffect.tscn")

	
func create_grass_effect():
	var grassEffect = GrassEffectScene.instance()
#	get_tree().current_scene.add_child(grassEffect)
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
