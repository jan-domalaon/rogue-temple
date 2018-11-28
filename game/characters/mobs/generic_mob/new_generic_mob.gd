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
export var detection_range = 100000
var detected_pos = Vector2(0, 0)

# State variables
var current_state

# Navigation variables
var nav = null setget set_nav
var path = [] 
onready var nav_map = get_parent().get_node("nav")
var old_player_pos

# Attacking logic
var can_attack = true
var shooting_range = 200	# Distance where mob can shoot at player

# Mob stats
# Amount of XP given
var mob_xp = 0


func _ready():
	set_nav(nav_map)
	player_pos = get_parent().get_node("player").get_global_position()
	path = nav.get_simple_path(get_global_position(), player_pos, false)
	$pathfinding_timer.start()


func _physics_process(delta):
	movement()
	# Use move dir if player can be seen
	if (detection_ray().collider.is_in_group("player")):
		var current_player_pos = get_parent().get_node("player").get_global_position()
		movement_dir = (current_player_pos - get_global_position()).normalized()
	# Else use pathfinding. Go to each node of the path
	else:
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
	update()


func _draw():
	if path.size() > 1:
		for node in path:
			draw_circle(node - position, 5, Color(0, 1, 1))
	draw_line(Vector2(), get_parent().get_node("player").position - get_global_position(), Color(1, 0, 0))


func set_nav(new_nav):
	nav = new_nav


func _on_pathfinding_timer_timeout():
	player_pos = get_parent().get_node("player").get_global_position()
	path = nav.get_simple_path(get_global_position(), player_pos, false)
	$pathfinding_timer.start()


func detection_ray():
	var current_player_pos = get_parent().get_node("player").get_global_position()
	var physics_space = get_world_2d().direct_space_state
	var ignore_areas = [self, $knockback_area]
	
	# Ignore mob mask (00101 == 5). Bit mask is in binary. Collides with players and walls only.
	var detect_ray = physics_space.intersect_ray(get_global_position(), current_player_pos, ignore_areas, 5)
	return detect_ray