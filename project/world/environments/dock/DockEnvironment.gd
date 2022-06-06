extends Node2D

# Setup number:
#   0 - initial
#   1 - return from town
export var spawn_setup : int = 0 setget set_spawn_setup

# TODO problem - what if this is set after ready? maybe emit signal?

# Reference to the SpawnController node
onready var SpawnController = $SpawnController

# On ready, move player and Lucia to the right spot
func _ready():
	print("_ready()")
	SpawnController.move(spawn_setup)

func set_spawn_setup(value):
	print("set_spawn_setup(" + str(value) + ")")
	# save the value we want to use
	spawn_setup = value
		# if not in tree, move the nodes later
	if not is_inside_tree():
		return
	# trigger the move via the SpawnController
	SpawnController.move(spawn_setup)
	
