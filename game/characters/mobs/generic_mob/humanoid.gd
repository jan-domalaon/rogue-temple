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
	$attack_timer.set_wait_time($weapon.get("secondary_as"))

func _process():
	pass

func state_melee_attack():
	# Check first if the mob can attack to prevent spamming
	if (can_attack && player_health > 0):
		$weapon.reset_weapon()
		can_attack = false
		$attack_timer.start()
		$weapon.make_downward_swing()
		pop_state()
		push_state("CHASING")

func state_ranged_attack():
	pass

func _on_attack_timer_timeout():
	can_attack = true