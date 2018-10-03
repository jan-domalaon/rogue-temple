extends "res://game/characters/character.gd"

# List of all possible states
var STATES = ["IDLE", "WANDERING", "CHASING", "RANGED_ATTACK", "MELEE_ATTACK"]

var wander_time = (randi()%3) + 1
var original_move_speed = move_speed
# Get player position for player detection
var player_pos

var state_stack = []
var current_state

func _ready():
	# Makes sure movement is random every time
	randomize()
	set_physics_process(true)
	state_stack.push_front(STATES[0])
	update_state()

func _physics_process(delta):
	# If I touch a wall and is not hit, change movement dir
	if (is_on_wall() and (not flickering)):
		movement_dir = Vector2(0,0)
	knockback()
	movement()
	detect_player()

func _on_wander_timer_timeout():
	# Get another random value
	wander_time = (randi()%3) + 1
	# Push either WANDER or IDLE, depending on what was pushed before.
	if (current_state == "IDLE"):
		state_stack.push_front("WANDERING")
	else:
		state_stack.push_front("IDLE")
	update_state()

func update_state():
	# Current state is top of stack
	current_state = state_stack.pop_front()
	match (current_state):
		"IDLE":
			state_idle()
		"WANDERING":
			state_wandering()
		"CHASING":
			state_chasing()

func state_idle():
	# Wait for some time
	movement_dir = Vector2(0, 0)
	$wander_timer.set_wait_time(wander_time)
	$wander_timer.start()

func state_wandering():
	# Walk for a random amount of time (1 - 10)
	wander_time = (randi()%3) + 1
	$wander_timer.set_wait_time(wander_time)
	$wander_timer.start()
	# Choose a random direction and go there
	random_move_dir()
	
	# Flip sprite depending on movement direction
	if (movement_dir.x == -1):
		$sprite.set_flip_h(true)
	elif (movement_dir.x == 1):
		$sprite.set_flip_h(false)
	
	# Random move speed when wandering (fraction of actual move speed)
	# Wander speed = (ms *. 75) / wander_mult
	var wander_mult = (randi()%3) + 2
	move_speed = original_move_speed / wander_mult

func state_chasing():
	print("chasing player!")
	# Add pathfinding

func state_ranged_attack():
	pass

func state_melee_attack():
	pass

func random_move_dir():
	# Give a random movement direction
	movement_dir.x = -int(randi()%2) + int(randi()%2)
	movement_dir.y = -int(randi()%2) + int(randi()%2)
	# If the random direction is (0, 0), randomize again
	if (movement_dir == Vector2(0,0)):
		random_move_dir()

func detect_player():
	player_pos = get_parent().get_node("player").get_global_position()
	var physics_space = get_world_2d().direct_space_state
	var detect_ray = physics_space.intersect_ray(get_global_position(), player_pos, [self, $knockback_area])
	if (detect_ray.position == player_pos):
		print(get_name(), " detected player")
