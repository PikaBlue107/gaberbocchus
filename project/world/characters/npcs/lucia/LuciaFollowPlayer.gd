extends Lucia


# Whether or not we're currently following the palyer
var player_follow = false
# If true, will run away instead of towards
var flee = false

# Variable to track the player
var Player : KinematicBody2D = null


func _physics_process(delta: float):
	# if not following the player, then do nothing
	if player_follow:
		# set Lucia's input_vector to be the distance between her and Adel
		input_vector = Player.global_position - global_position
		# if flee, reverse it
		if flee:
			input_vector = -input_vector
	else:
		# tell Lucia to stop
		input_vector = Vector2.ZERO
	

func _on_BeginFollowZone_player_entered():
	player_follow = true
	Player = $BeginFollowZone.player

func _on_BeginFollowZone_player_exited():
	player_follow = false


func _on_CloseEnoughZone_player_entered():
	player_follow = false

func _on_CloseEnoughZone_player_exited():
	player_follow = true


func _on_BackUpZone_player_entered():
	player_follow = true
	flee = true

func _on_BackUpZone_player_exited():
	player_follow = false
	flee = false
