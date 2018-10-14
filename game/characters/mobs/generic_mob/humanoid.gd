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

func state_melee_attack():
	# Keep the weapon hitbox disabled if the mob is not attacking
	# FOR USE WITH DOWNWARD SWING
	$weapon/weapon_area/hitbox.set_disabled(true)
	# Mob can attack when cooldown is finished and player is still alive
	if (can_attack and player_health > 0 and not flickering):
		print("melee state ", state_stack)
		can_attack = false
		$attack_timer.start()
		$weapon.make_downward_swing()
		pop_state()
		push_state("CHASING")

func state_ranged_attack():
	pass

func _on_attack_timer_timeout():
	can_attack = true