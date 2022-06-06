tool
extends PlayerDetectionZone

export var scene_name : String = "dock"
export var scene_spawn_setup : int = 0

func _on_PlayerOverlapSceneChange_player_entered():
	var World = get_node("/root/GameWorld") # as GameWorld # causes circular dependency
	World.change_scene(scene_name, scene_spawn_setup) # TODO: refactor into signal
	
