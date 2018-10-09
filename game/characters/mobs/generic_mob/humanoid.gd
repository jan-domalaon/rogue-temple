# By Jan Domalaon

# Humanoid AI script.
# Borrows from generic mob, but can use ranged and melee attacks

extends "res://game/characters/mobs/generic_mob/generic_mob.gd"

# Weapon choices
export var melee_weapon_path = ""
export var ranged_weapon_path = ""
export var weapon_type = ""

# Weapon range retrieved from weapon's length/weapon_range
# (size of weapon.x)
onready var weapon_length = get_node("weapon/weapon_area/hitbox").shape.extents.x

func _ready():
	randomize()
	print(weapon_length)
	pass

func _process():
	pass

func state_melee_attack():
	$weapon.look_at(player_pos)
	$weapon.make_swing()
	pop_state()
	push_state("CHASING")


func state_ranged_attack():
	pass