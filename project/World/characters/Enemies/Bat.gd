extends KinematicBody2D



#--------Types--------
# State Machine
enum {
	IDLE,
	WANDER,
	CHASE,
}



#--------Exports--------
export var ACCELERATION = 300
export var MAX_SPEED = 50
export var MOVE_FRICTION = 200
export var KNOCKBACK_FRICTION = 200
export var KNOCKBACK_STRENGTH = 120



#--------References--------
# Graphics
onready var sprite = $AnimatedSprite
# Physics
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftColllision
onready var wanderController = $WanderController
onready var hurtbox = $Hurtbox
# Stats
onready var stats = $Stats



#--------Resources--------
# Graphics
const EnemyDeathEffectScene = preload("res://world/effects/enemy_death/EnemyDeathEffect.tscn")




#--------Variables--------
# Movement
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE



#--------Virtual Functions--------

## On physics update, handle all movement and state behavior
func _physics_process(delta):
	
	# handle knockback before velocity
	_knockback_process(delta)
	
	# run current state
	match state:
		IDLE:
			# Friction to slow down
			velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
			
		WANDER:
			# Move towards wander target
			_move_towards(wanderController.target_position, delta)
		
		CHASE:
			# move towards the player if the zone has seen it yet
			var player = playerDetectionZone.player
			if player != null:
				_move_towards(player.global_position, delta)
				
	# handle soft collisions
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	# adjust sprite to match velocity
	sprite.flip_h = velocity.x < 0
	# perform movement
	velocity = move_and_slide(velocity)



#--------Signal Handlers--------

## When hurtbox entered, take damage from the hitbox, and apply knockback.
func _on_Hurtbox_area_entered(area):
	stats.take_damage(area.damage)
	knockback = area.knockback_vector * KNOCKBACK_STRENGTH
#	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	

## When the bat runs out of health, die and play a death effect
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffectScene.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


# enter/exit CHASE state based on player proximity

## When the player enters the detection zone, switch to Chase state
## (and cancel the current wander segment so that it doesn't interrupt )
func _on_PlayerDetectionZone_player_entered():
	state = CHASE
	wanderController.cancel_segment()

## When the player exist the bat's detection zone, pick a new state.
func _on_PlayerDetectionZone_player_exited():
	_start_passive_state([IDLE, IDLE, WANDER]) # more weight towards IDLE

## When a wander segment finishes, pick a new state.
func _on_WanderController_segment_finish():
	_start_passive_state()



#--------Private Functions--------

## Process knockback on the bat
func _knockback_process(delta):
	knockback = move_and_slide(knockback)
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	
## Move towards a target position, for some reason or another.
## Adjust sprite to match.
func _move_towards(target_position: Vector2, delta):
	var direction_to_target = \
			global_position.direction_to(target_position)
	velocity = velocity.move_toward(
			direction_to_target * MAX_SPEED, ACCELERATION * delta)

## Move to a new "passive" state.
## Default weight is 2/3 Wander, 1/3 Idle.
func _start_passive_state(state_list: Array = [IDLE, WANDER, WANDER]):
	# pick a random state from the list
	state_list.shuffle()
	state = state_list.pop_front()
	# set a wander segment regardless of state - use as timer to switch
	wanderController.start_wander_segment()
