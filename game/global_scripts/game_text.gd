# By Jan Domalaon
# Game text. Contains all statements (except level) for game_log in player_hud


extends Node


# Text colors
const COLOR_DEFAULT = Color(1,1,1)				# White
const COLOR_KILLED = Color(1,0,0)				# Red
const COLOR_INTERACT = Color(1,0,0.9)			# Purple

# Damage flavor text


func character_damaged(victim_name, dmg, dmg_type, is_dead):
	# Give appropriate death message
	if is_dead:
		return victim_name + " has died!"
	else:
		var d_type
		if (dmg_type == "b"):
			d_type = "blunt"
		elif (dmg_type == "c"):
			d_type = "cut"
		else:
			d_type = "piercing"
		# For now, default damage text
		return victim_name + " has been hurt for " + str(dmg) + " " + d_type + " damage."


func opened_door(user_name):
	# For now, only player prints a statement when opening a door
	return user_name + " has opened a door."


func flipped_switch(user_name):
	return user_name + " has flipped a switch."