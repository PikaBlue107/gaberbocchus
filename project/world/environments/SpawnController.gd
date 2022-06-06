extends Node2D

# type hinting not yet supported :(
# Dictionary<NodePath, List<Node2D>>
# 	NodePath: the node to be positioned
#	List of PositionAndRotation: list of spawn positions, including position and rotation
export var spawn_locations : Dictionary

## Move each key of spawn_locations to the position at spawn_locations[node][index]
func move(index):
	print("SpawnController.move(" + str(index) + ")")
	# Loop thru each key in spawn_locations
	for node_path in spawn_locations:
		# Get the node to move
		var node = get_node(node_path) as Node2D # TODO: warning if this doesn't work?
		# Check if there's a position to be used at this index
		if index >= spawn_locations[node_path].size():
			continue # skip - just leave it where it is
			
		# Change position
		# TODO: warning if this doesn't work?
		var target = get_node(spawn_locations[node_path][index]) as PositionAndRotation
		# Set the position
		node.global_position = target.global_position
		
		# Change facing direction
		# if field 'facing' not in node, skip
		if not 'facing' in node:
			continue
		# set facing direction
		print("  setting node.facing = " + str(target.dir_as_vector()))
		node.facing = target.dir_as_vector()
		
