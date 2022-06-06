class_name GameWorld
extends Node2D

#--------Exports--------
export var FADE_TIME = 0.5

#--------Private variales--------
onready var FadeModulate = $FadeModulate
onready var Contents = $Contents
# Map from names to scenes
const scenes : Dictionary = {  # Dictionary[String, PackedScene]
	"dock": preload("res://world/environments/dock/DockEnvironment.tscn"),
	"town": preload("res://world/environments/town/TownEnvironment.tscn"),
	"apothecary_groundfloor": preload("res://world/environments/apothecary/ground_floor/GroundFloorEnvironment.tscn"),
	"apothecary_hallway": preload("res://world/environments/apothecary/2floor_hallway/HallwayEnvironment.tscn"),
	"apothecary_bedroom": preload("res://world/environments/apothecary/bedroom/BedroomEnvironment.tscn"),
	"dream": preload("res://world/environments/dream/DreamEnvironment.tscn"),
	"forest": null,
	"temple_exterior": null,
	"temple_entrance": null,
	"temple_stairs": null,
	"temple_prearena": null,
	"temple_arena": null
}

func change_scene(scene_name: String,
	scene_spawn_setup: int = 0,
	fade_out_duration: float = FADE_TIME,
	fade_in_duration: float = FADE_TIME):
	
#	print("GameWorld.change_scene(" + scene_name + ")")
	
	# Ensure the scene we want is in the map
	assert(scene_name in scenes, "ERROR: Tried to load scene \"" + scene_name + \
		"\", but there isn't an entry for that name in GlobalUtil.change_scene()!")
	assert(scenes[scene_name] != null, "ERROR: Tried to load scene \"" + scene_name + \
		"\", but it's still `null` in GlobalUtil.change_scene()!")
	
	# Pause the game
	get_tree().paused = true
	
	# Fade to black
	# create a FadeModulate to handle the transition
	# config
	FadeModulate.fade_duration = fade_out_duration
	FadeModulate.target_color = Color.white # TODO: .black
	# launch
	FadeModulate.start()
	# Wait for it to finish
	yield(FadeModulate, "fade_done")
	
	# Set the scene
	# Clear all children of Contents
	Utils.delete_children(Contents)
	# Create an instance of the desired scene
	var NewScene = scenes[scene_name].instance()
	# Set its spawn setup
	if "spawn_setup" in NewScene:
		NewScene.spawn_setup = scene_spawn_setup
	# Add that scene to the World
	Contents.add_child(NewScene)
	
	# Fade back in
	FadeModulate.fade_duration = fade_in_duration
	FadeModulate.target_color = Color.white
	FadeModulate.restart()
	# Wait for it to finish
	yield(FadeModulate, "fade_done")
	
	# Unpause the game
	get_tree().paused = false
