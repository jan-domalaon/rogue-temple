# By Jan Domalaon
# Script for mobs (ie any enemy character)


extends "res://game/characters/character.gd"

# List of all possible states
var STATES = ["IDLE", "WANDERING", "CHASING", "RANGED_ATTACKING", "MELEE_ATTACKING"]

# Movement and wandering vars
var wander_time = (randi()%3) + 1
var wander_counter = 0
onready var original_move_speed = move_speed

# Get player position for player detection
var player_pos
onready var player_health = get_parent().get_node("player").get("health")

# Detected flag used to push CHASING state only once when detected
var detected = false
export var detection_range = 100000

# State variables
var state_stack = []
var current_state

# Navigation variables
var nav = null setget set_nav
var path = [] 
onready var nav_map = get_parent().get_node("nav")
var old_player_pos

# Attacking logic
var can_attack = true

# Mob stats
# Amount of XP given
var mob_xp = 0


func _ready():
	# Makes sure movement is random every time
	randomize()
	set_physics_process(true)
	push_state("IDLE")
	wander_counter = wander_time
	update_state()
	
	nav = nav_map
	# Get player's signal
	get_parent().get_node("player").connect("player_moved", self, "on_player_movement")


func _physics_process(delta):
	# If I touch a wall and is not hit, change movement dir
#	if (is_on_wall() and (not flickering)):
#		movement_dir = Vector2(0,0)
	knockback()
	movement()
	# Update detection only when the player is alive
	player_health = get_parent().get_node("player").get("health")
	if (player_health > 0):
		if (not detected):
			detect_player()
		# Only update state per frame when not in passive states
	if (get_current_state() != STATES[0] and get_current_state() != STATES[1] and get_current_state() != STATES[3]):
		update_state()
	old_player_pos = player_pos


func _on_wander_timer_timeout():
	var current_state = get_current_state()
	# Get another random value
	wander_time = (randi()%3) + 1
	# Pop WANDER/IDLE state
	pop_state()
	# Push either WANDER or IDLE, depending on what was pushed before.
	if (current_state == "IDLE"):
		push_state("WANDERING")
	else:
		push_state("IDLE")
	update_state()

func _update_path():
	path = nav.get_simple_path(get_global_position(), player_pos, false)


func update_state():
	var current_state = get_current_state()
	#print(state_stack)
	if (get_current_state() != null):
		match current_state:
			"IDLE":
				state_idle()
			"WANDERING":
				state_wandering()
			"CHASING":
				state_chasing()
			"MELEE_ATTACKING":
				state_melee_attack()
			"RANGED_ATTACKING":
				state_ranged_attack()


func pop_state():
	return state_stack.pop_front()


func push_state(state):
	if (get_current_state() != state):
		# Push state to stack
		state_stack.push_front(state)


func get_current_state():
	if (state_stack.size() > 0):
		# Get top of stack
		return state_stack[state_stack.size() - 1]
	else:
		return null


func state_idle():
	# Wait for some time
	movement_dir = Vector2(0, 0)
	$wander_timer.set_wait_time(wander_time)
	$wander_timer.start()
	wander_time = (randi()%3) + 1
#	wander_countdown(wander_time, STATES[0])


func state_wandering():
	# Walk for a random amount of time (1 - 10)
	wander_time = (randi()%3) + 1
	$wander_timer.set_wait_time(wander_time)
	$wander_timer.start()
#	wander_countdown(wander_time, STATES[1])
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
	# Set move speed back to normal
	move_speed = original_move_speed
	
	# Chase down player. Use simple move_dir if player is visible
	# Use pathfinding if the player is behind a wall
	var detect_ray = detection_ray()
	if ("player" in detect_ray.collider.get_parent().get_groups()):
		movement_dir = player_pos - self.position
#		if (not "player" in detect_ray.collider.get_parent().get_groups()):
#			if (player_pos != old_player_pos):
#				set_nav(nav_map)
#			pathfinding()
	else:
		# Use pathfinding
		#print("path finding!")
		if (player_pos != old_player_pos):
			set_nav(nav_map)
		pathfinding()
	
	# Stay in CHASING while the player is still alive
	# If not a bouncy_mob, this mob will have a weapon
	# Choose preferred weapon depending on distance
	if ("ranged_mobs" in get_groups()):
		pass
	if ("melee_mobs" in get_groups() and not ("ranged_mobs" in get_groups())):
		# If in melee range, switch to melee attack
		var weapon_length = get_node("weapon/weapon_area/hitbox").shape.extents.x
		var distance_vector = (get_global_transform().origin - player_pos).length()
		if (distance_vector <= weapon_length):
			pop_state()
			push_state("MELEE_ATTACKING")


func state_ranged_attack():
	# Code in humanoid.gd
	pass


func state_melee_attack():
	# Code in humanoid.gd
	pass


func random_move_dir():
	# Give a random movement direction
	movement_dir.x = -int(randi()%2) + int(randi()%2)
	movement_dir.y = -int(randi()%2) + int(randi()%2)
	# If the random direction is (0, 0), randomize again
	if (movement_dir == Vector2(0,0)):
		random_move_dir()


func detection_ray():
	player_pos = get_parent().get_node("player").get_global_position()
	var physics_space = get_world_2d().direct_space_state
	var ignore_areas
	if ("humanoids" in get_groups()):
		ignore_areas = [self, $knockback_area, $weapon]
	else:
		ignore_areas = [self, $knockback_area]
	
	# Ignore mob mask (1101 == 13). Bit mask is in binary
	var detect_ray = physics_space.intersect_ray(get_global_position(), player_pos, ignore_areas)
	#print(detect_ray.collider.get_parent().get_groups())
	return detect_ray


func detect_player():
	var detect_ray = detection_ray()
	var dist_to_player = get_global_position().distance_to(player_pos)
	print(detect_ray.collider.get_parent().get_groups())
	# Check if raycast hits player and is within detection range
	if ("player" in detect_ray.collider.get_parent().get_groups() and dist_to_player <= detection_range):
		# Player is detected. Push CHASING state to trigger aggressive behaviour
		$wander_timer.stop()
		# Pop current passive state
		pop_state()
		detected = true
		push_state("CHASING")
		update_state()


func set_nav(new_nav):
	nav = new_nav
	old_player_pos = player_pos
	_update_path()



func pathfinding():
	if path.size() > 1:
		var dist = get_global_position().distance_to(path[0])
		if dist > 2:
			# Move to next path node
			movement_dir = path[0] - self.position
		else:
			path.remove(0)
	else:
		movement_dir = Vector2(0,0)


func on_player_movement(pos):
	player_pos = pos
	var detect_ray = detection_ray()
	if (not ("player" in detect_ray.collider.get_parent().get_groups())):
		if (pos != old_player_pos):
			set_nav(nav_map)
		pathfinding()


func _on_attack_timer_timeout():
	pass
