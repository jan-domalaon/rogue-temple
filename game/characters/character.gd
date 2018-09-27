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

func receive_phys_damage(body):
	# Remove HP from this character based on the damage stat of weapon
	# Piercing damage. Goes through armor.
#	if (dmg_type == 'p'):
#		body.health -= dmg
#	else:
#		# Blunt damage. Add knockback.
#		if (dmg_type == 'b'):
#			pass
#		# If dmg is greater than physical resistance, damage.
#		# If not, the player will not damage the enemy.
#		if (dmg > phys_resist):
#			body.health -= (dmg - phys_resist)
#	print(body.health)
	pass