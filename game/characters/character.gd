extends KinematicBody2D

# Various stats for characters
var health = 1
var armor = 0
var move_speed = 100

# Physical resistance of all characters
var phys_resist = armor * 0.8

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func receive_phys_damage(body):
	# Remove HP from this character based on the damage stat of weapon
		# Piercing damage. Goes through armor.
		if (dmg_type == 'p'):
			body.health -= dmg
		else:
			# Blunt damage. Add knockback.
			if (dmg_type == 'b'):
				pass
			# If dmg is greater than physical resistance, damage.
			# If not, the player will not damage the enemy.
			if (dmg > phys_resist):
				body.health -= (dmg - phys_resist)
	print(body.health)