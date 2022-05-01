tool
extends PlayerDetectionZone

export var scene_name : String = "dock"

func _on_PlayerOverlapSceneChange_player_entered():
	var World = get_node("/root/GameWorld") # as GameWorld # causes circular dependency
	World.change_scene(scene_name)
	
