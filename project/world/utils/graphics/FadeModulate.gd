extends Node

#--------Signals--------
signal fade_done

#--------Exports--------
export(NodePath) var target_node = "/root" setget set_target_node
export(Color) var target_color = Color.black
export(float) var fade_duration = 1.0 # in seconds


#--------Private variables--------
var target_node_inst : CanvasItem = null
var original_color : Color
var time_running : float = 0
var running : bool = false

##--------Public Methods--------
## Launch the transition
func start():
#	print("FadeModulate.start()")
	# if not yet in scene, wait until we are
	if not is_inside_tree():
		yield(self, 'ready');
#	print("FadeModulate ready!")
	# setup the target node
	_try_get_target_node()
	assert(target_node_inst != null, "still not ready in start function")
	# start everything running
	running = true
	time_running = 0
#	print("FadeMoudlate.start() - complete!")
## Restart the transition, updating to any new nodes or durations
func restart(): # alias
	start()

#--------Getters & Setters--------
func set_target_node(value: NodePath):
	target_node = value
	_try_get_target_node()


#--------Override Methods--------
func _physics_process(delta):
#func _process(delta):
	# if not running, skip
	if not running:
		return
	# if the target node hasn't been setup yet, try to set it up
	if target_node_inst == null:
		# try to get the taret node
		_try_get_target_node()
		# if it's still not there, complain
		if target_node_inst == null:
			print("WARN: skipping FadeModulate._process() because " + 
					"target node (" + target_node + ") doesn't exist")
			return
	# target_node_inst exists
	
	# if we're already done don't bother
	if time_running >= fade_duration:
		return
	
	# count up time, compute weight
	time_running += delta
#	print("time_running up to " + str(time_running))
	var weight = min(1.0, time_running / fade_duration)
#	print("weight = time_running / fade_duration = " + str(weight))
	# lerp between original color and target color
	target_node_inst.modulate = original_color.linear_interpolate(target_color, weight)
	
	# if we've reached the color, emit a signal
	if weight == 1.0:
		running = false
		emit_signal("fade_done")

#--------Private Helpers--------
func _try_get_target_node():
	# so much error checking ;-;
	# if this node is not in the tree, don't bother trying
	if not is_inside_tree():
#		print("not in tree, returning...")
		return
	# try to get the actual node from the tree
	var test_node = get_node_or_null(target_node)
	# if it's not there, just wait until later
	if test_node == null:
#		print("get_node is null, returning...")
		return
	# if it's the wrong type, then complain
	assert(test_node is CanvasItem, "Provided node path of \"" + str(target_node) +
			"\" is of type " + test_node.get_class() + ", not CanvasItem!")
	
	# all good = set the instance
	target_node_inst = test_node
	# save the original color of the node
	original_color = target_node_inst.modulate
#	print("saved original color as " + str(original_color))
