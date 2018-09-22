extends "res://game/characters/character.gd"

# TODO: AI - states, state change triggers.

# State is either 'IDLE', 'CHASING', 'ATTACKING_MELEE', 'ATTACKING_RANGED', 'RETREATING'
var state = 'IDLE'

func _ready():
	set_physics_process(true)

func _process(delta):
	# Check for death. player_weapons will subtract the health.
	if (health <= 0):
		print(get_name() + ' is deadaz')
		queue_free()

func _physics_process(delta):
	knockback()