extends KinematicBody2D

# Various stats for characters
export (int) var health = 1
export (int) var armor = 0
export (int) var move_speed = 100

# Physical resistance of all characters
var phys_resist = armor * 0.8

# Vars on knockback mechanic
var knockback_counter = 0
var knockback_dir = Vector2(0, 0)
export var knockback_factor = 1.0

var movement_dir = Vector2(0, 0)

func movement():
	var motion
	if (knockback_counter == 0):
		motion = movement_dir.normalized() * move_speed
	else:
		motion = knockback_dir.normalized() * move_speed * knockback_factor
	move_and_slide(motion, Vector2(0, 0))

func knockback():
	# Knockback countdown
	if (knockback_counter > 0):
		knockback_counter -= 1
	for body in $knockback_area.get_overlapping_bodies():
		# Knockback if THIS character is an enemy and touches a player
		if (knockback_counter == 0 && ("bouncy_mobs" in get_groups() && "player" in body.get_groups()) or 
		("player" in get_groups() && "bouncy_mobs" in body.get_groups())):
			# Start knockback counter
			knockback_counter = 5
			knockback_dir = transform.origin - body.transform.origin
		
		# Knockback if THIS character touches blunt damage (Player hits mob (this))
		if (knockback_counter == 0 && ("enemies" in get_groups() && "blunt_weapons" in body.get_groups())):
			knockback_counter = 5
			knockback_dir = transform.origin - body.transform.origin
		# Knockback if THIS character touches blunt damage (Mob hits player (this))

func receive_phys_damage(dmg, dmg_type):
	# Remove HP from this character based on the damage stat of weapon
	# TODO: Armor reduction formula
	if (dmg_type == 'c'):
		health -= dmg
		print($".".get_name() + " got hit with cut dmg")
	elif (dmg_type == 'p'):
		# Piercing damage. Goes through armor.
		health -= dmg
		print($".".get_name() + " got hit with pierce dmg")
	elif (dmg_type == 'b'):
		# Blunt dmg. Do knockback
		health -= dmg
		print($".".get_name() + " got hit with blunt dmg")