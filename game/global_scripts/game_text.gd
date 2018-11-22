# By Jan Domalaon
# Game text. Contains all statements (except level) for game_log in player_hud


extends Node


# Text colors
const COLOR_DEFAULT = Color(1,1,1)				# White
const COLOR_KILLED = Color(1,0,0)				# Red
const COLOR_INTERACT = Color(0.33,0.18,0.9)		# Purple

# Damage flavor text


func character_damaged(victim_name, dmg, dmg_type, is_dead):
	# Give appropriate death message
	if is_dead:
		return victim_name + " has died!"
	else:
		# For now, default damage text
		return victim_name + " has been hurt for " + str(dmg) + " " + dmg_type + " damage."


func opened_door(user_name):
	# For now, only player prints a statement when opening a door
	return user_name + " has opened a door. \n"


func flipped_switch(user_name):
	return user_name + " has flipped a switch. \n"