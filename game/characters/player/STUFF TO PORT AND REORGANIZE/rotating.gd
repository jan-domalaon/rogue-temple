# By Jan Domalaon (MaritimesGameworks)

extends Node2D

# Script responsible for delivering damage to NPCs from an equipped weapon


func _on_weapon_body_enter(body):
	if (body.is_in_group('enemies')):
		# Default physical resistance
		var PHYSICAL_RESIST = body.armor * 0.8
		
		var phys_resist = PHYSICAL_RESIST
		var dmg = get_parent().player_dmg[0]
		var dmg_type = get_parent().player_dmg[1]
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
