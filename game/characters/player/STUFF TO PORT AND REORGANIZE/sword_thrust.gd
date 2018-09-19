# By Jan Domalaon (MaritimesGameworks)

# A default weapon. Used for testing. Same stats as an iron sword.

extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_sword_body_enter( body ):
	# Damage enemy types. Check for enemy group.
	if ('enemies' in body.get_groups()):
		var phys_resist = body.armor * 0.8
		var dmg = get_parent().get_parent().player_dmg[0]
		var dmg_type = get_parent().get_parent().player_dmg[1]
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

