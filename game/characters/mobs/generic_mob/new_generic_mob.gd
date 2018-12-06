extends "res://game/characters/character.gd"


# List of all possible states
var STATES = ["IDLE", "WANDERING", "CHASING", "RANGED_ATTACKING", "MELEE_ATTACKING"]

# Movement and wandering vars
var wander_time = (randi()%3) + 1
var wander_counter = 0
onready var original_move_speed = move_speed

# Get player position for player detection
var player_pos
var player_health = 1

# Detected flag used to push CHASING state only once when detected
var detected = false
export var detection_range = 100
var detected_pos = Vector2(0, 0)

# State variables
var current_state

# Navigation variables
var nav = null setget set_nav
var path = [] 
onready var nav_map = get_parent().get_node("nav")
var old_player_pos
var move_dir_chase = false

# Attacking logic
var can_attack = true
export var shooting_range = 200		# Distance where mob can shoot at player

# Mob stats
# Amount of XP given
var mob_xp = 0
export (Color) var mob_color = Color(1,1,1)
export var knockbackable = true

# For weapon wielding mobs
var weapon_length = 0


func _ready():
	set_nav(nav_map)
	player_pos = get_parent().get_node("player").get_global_position()
	path = nav.get_simple_path(get_global_position(), player_pos, false)
	$pathfinding_timer.start()
	
	# Start in passive states
	current_state = "IDLE"
	state_idle()
	
	# Get weapon range for ability to attack
	if (is_in_group("melee_mobs")):
		weapon_length = get_node("weapon/weapon_area/hitbox").shape.extents.x


func _physics_process(delta):
	# Mobs have the ability to move
	movement()
	# Mobs can be knocked back
	if (knockbackable):
		knockback()
	
	var current_player_pos = get_parent().get_node("player").get_global_position()
	# If the player is within detection range and is seen, switch to aggressive mode. Detected = true
	if (not detected and (get_global_position().distance_to(current_player_pos) <= detection_range) and detect_ray(get_global_position(), current_player_pos) ):
		# Set detected flag to true. Set movement back to normal. Transition to aggressive states
		detected = true
		move_speed = original_move_speed
	
	# If detected, switch to aggressive states
	if detected:
		state_chasing()
		current_state = "CHASE"
#	update()
#
#
#func _draw():
#	if path.size() > 1:
#		for node in path:
#			draw_circle(node - position, 5, Color(0, 1, 1))
#	var current_player_pos = get_parent().get_node("player").get_global_position()
#	var player_extents = get_parent().get_node("player/hitbox").shape.extents - Vector2(3, 3)
#	var mob_extents = $hitbox.shape.extents - Vector2(1, 1)
#
#	var nw = current_player_pos - player_extents
#	var se = current_player_pos + player_extents
#	var ne = current_player_pos + Vector2(player_extents.x, -player_extents.y)
#	var sw = current_player_pos + Vector2(-player_extents.x, player_extents.y)
#
#	var mob_nw = get_global_position() - mob_extents
#	var mob_se = get_global_position() + mob_extents
#	var mob_ne = get_global_position() + Vector2(mob_extents.x, -mob_extents.y)
#	var mob_sw = get_global_position() + Vector2(-mob_extents.x, mob_extents.y)
#
#	draw_line(Vector2(), nw - mob_nw, Color(1, 0, 0))
#	draw_line(Vector2(), se - mob_se, Color(1, 0, 0))
#	draw_line(Vector2(), ne - mob_ne, Color(1, 0, 0))
#	draw_line(Vector2(), sw - mob_sw, Color(1, 0, 0))


func set_nav(new_nav):
	nav = new_nav


func _on_pathfinding_timer_timeout():
	set_new_path()


func set_new_path():
	set_nav(nav_map)
	player_pos = get_parent().get_node("player").get_global_position()
	path = nav.get_simple_path(get_global_position(), player_pos, false)
	$pathfinding_timer.start()


func pathfinding():
	if path.size() > 1:
		var dist = path[0] - get_global_position()
		if dist.length() > 2:
			# Move to next path node
			movement_dir = (path[0] - get_global_position()).normalized()
		else:
			path.remove(0)
	else:
		print("no more path nodes")
		movement_dir = Vector2(0,0)


func detection():
	var current_player_pos = get_parent().get_node("player").get_global_position()
	var player_extents = get_parent().get_node("player/hitbox").shape.extents - Vector2(3, 3)
	
	var nw = current_player_pos - player_extents
	var se = current_player_pos + player_extents
	var ne = current_player_pos + Vector2(player_extents.x, -player_extents.y)
	var sw = current_player_pos + Vector2(-player_extents.x, player_extents.y)
	
	for pos in [nw, ne, se, sw]:
		print(detect_ray(pos, current_player_pos))


func detect_ray(target_position, player_pos):
	var physics_space = get_world_2d().direct_space_state
	var ignore_areas = [self, $knockback_area]
	# Ignore mob mask (00101 == 5). Bit mask is in binary. Collides with players and walls only.
	var detect_ray = physics_space.intersect_ray(target_position, player_pos, ignore_areas, 5)
	if (detect_ray.collider.is_in_group("player")):
		return true
	else:
		return false


func state_chasing():
	# Chasing state. Handles pathfinding going towards players
	var current_player_pos = get_parent().get_node("player").get_global_position()
	var player_extents = get_parent().get_node("player/hitbox").shape.extents - Vector2(3, 3)
	var mob_extents = $hitbox.shape.extents - Vector2(1, 1)
	
	var nw = current_player_pos - player_extents
	var se = current_player_pos + player_extents
	var ne = current_player_pos + Vector2(player_extents.x, -player_extents.y)
	var sw = current_player_pos + Vector2(-player_extents.x, player_extents.y)
	
	var mob_nw = get_global_position() - mob_extents
	var mob_se = get_global_position() + mob_extents
	var mob_ne = get_global_position() + Vector2(mob_extents.x, -mob_extents.y)
	var mob_sw = get_global_position() + Vector2(-mob_extents.x, mob_extents.y)
	
	# If player can be seen, use move dir
	# If mob is humanoid and can see player and is within weapon range, do weapon attack
	if (detect_ray(mob_nw, nw) and detect_ray(mob_se, se) and detect_ray(mob_ne, ne) and detect_ray(mob_sw, sw)):
		# If this mob is a humanoid
		# Only chase if the player is not within weapon range
		if (is_in_group("melee_mobs") and (get_global_transform().origin - current_player_pos).length() <= weapon_length):
			state_melee_attack()
			current_state = "MELEE_ATTACK"
		elif (is_in_group("ranged_mobs") and position.distance_to(player_pos) <= shooting_range):
			state_ranged_attack()
			current_state = "RANGED_ATTACK"
		else:
			# Use move dir if player can be seen by all corners
			# Mobs without weapons will "bounce" off the player, dealing damage when touching
			movement_dir = (current_player_pos - get_global_position()).normalized()
			move_dir_chase = true
	# Else use pathfinding. Go to each node of the path
	else:
		if (move_dir_chase):
			# Get a new path by forcing pathfinding timer to time out
			$pathfinding_timer.stop()
			set_new_path()
			move_dir_chase = false
		else:
			pathfinding()


func state_idle():
	# This mob is idle. Not moving
	movement_dir = Vector2(0,0)
	
	# Reduce movement speed by half
	move_speed = int(original_move_speed * 0.5)
	
	# Get new passive wait time. Start timer
	$passive_timer.set_wait_time((randi()%3) + 1)
	$passive_timer.start()


func state_wander(random_move_dir):
	movement_dir = random_move_dir
	
	# Reduce movement speed by half
	move_speed = int(original_move_speed * 0.5)
	
	# Get new passive wait time. Start timer
	$passive_timer.set_wait_time((randi()%3) + 1)
	$passive_timer.start()


func get_random_movement_dir():
	# Give a random movement direction
	var random_dir = Vector2(0,0)
	random_dir.x = -int(randi()%2) + int(randi()%2)
	random_dir.y = -int(randi()%2) + int(randi()%2)
	# If the random direction is (0, 0), randomize again
	if (random_dir == Vector2(0,0)):
		random_dir = get_random_movement_dir()
	return random_dir


func _on_passive_timer_timeout():
	# Handle state transition. Only transition between passive states
	if not detected:
		if (current_state == "IDLE"):
			current_state = "WANDER"
			state_wander(get_random_movement_dir())
		elif (current_state == "WANDER"):
			current_state = "IDLE"
			state_idle()
