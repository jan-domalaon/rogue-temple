extends Area2D

export var weapon_name = "Weapon (Parent Weapon)"
export var primary_damage = 1
export var secondary_damage = 1
export var primary_dmg_type = 'c'
export var secondary_dmg_type = 'p'
export var user_type = "player"

func _ready():
	pass

func _on_weapon_body_entered(body):
	if (user_type == "player" && ("enemies" in body.get_groups())):
		# Get parent of this weapon and receive_dmg()
		pass