extends KinematicBody2D

# TODO: AI - states, state change triggers.

export var move_speed = 100
export var health = 4
# State is either 'IDLE', 'CHASING', 'ATTACKING_MELEE', 'ATTACKING_RANGED', 'RETREATING'
var state = 'IDLE'

func _ready():
	set_process(true)

func _process(delta):
	# Check for death. player_weapons will subtract the health.
	if (health <= 0):
		print(get_name() + ' is deadaz')
		queue_free()

