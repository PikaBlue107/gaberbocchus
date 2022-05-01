extends Node

func change_scene(scene_name: String):
	
	# Declare a map from names to scenes
	var scenes = {
		"dock": preload("res://world/environments/dock/DockEnvironment.tscn"),
		"town": preload("res://world/environments/town/TownEnvironment.tscn"),
		"apothecary_groundfloor": null,
		"apothecary_hallway": null,
		"apothecary_bedroom": null,
		"dream": null,
		"forest": null,
		"temple_exterior": null,
		"temple_entrance": null,
		"temple_stairs": null,
		"temple_prearena": null,
		"temple_arena": null
	}
	
	# Ensure the scene we want is in the map
	assert(scene_name in scenes, "ERROR: Tried to load scene \"" + scene_name + \
		"\", but there isn't an entry for that name in GlobalUtil.change_scene()!")
	
	# Set the scene
	get_tree().change_scene_to(scenes[scene_name])
		
