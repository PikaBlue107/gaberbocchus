tool
extends PlayerDetectionZone

export var scene_name : String = "dock"

func _on_PlayerOverlapSceneChange_player_entered():
	GlobalUtil.change_scene(scene_name)
