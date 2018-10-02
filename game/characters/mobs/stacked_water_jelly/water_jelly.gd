extends "res://game/characters/character.gd"

# TODO: AI - states, state change triggers.

# State is either 'IDLE', 'CHASING', 'ATTACKING_MELEE', 'ATTACKING_RANGED', 'RETREATING'
var state = 'IDLE'

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	# This mob is knockbackable
	knockback()
	movement()

func _on_knockback_area_body_entered(body):
	if ("player" in body.get_groups()):
		body.flicker()
	pass
