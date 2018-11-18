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
var state_stack = []
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
	pass


func _physics_process(delta):
	pass


func 