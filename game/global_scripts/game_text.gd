# By Jan Domalaon
# Game text. Contains all statements (except level) for game_log in player_hud


extends Node


# Text colors
const COLOR_DEFAULT = Color(1,1,1)				# White
const COLOR_KILLED = Color(1,0,0)				# Red
const COLOR_INTERACT = Color(1,0,0.9)			# Purple
const COLOR_BLOCK = Color (0.46,0.97,1)			# Aqua

# Damage flavor text


func character_damaged(victim_name, dmg, dmg_type):
	# Indicate what kind of damage was dealt
	var d_type
	if (dmg_type == "b"):
		d_type = "blunt"
	elif (dmg_type == "c"):
		d_type = "cut"
	elif (dmg_type == "p"):
		d_type = "piercing"
	elif (dmg_type == "x"):
		d_type = "pure"
	# For now, default damage text
	return victim_name + " has been hurt for " + str(dmg) + " " + d_type + " damage."


func character_died(victim_name):
	# Give appropriate death message
	return victim_name + " has died!"


func character_pitfallen(victim_name):
	return victim_name + " has fallen into a hole!"


func opened_door(user_name):
	# For now, only player prints a statement when opening a door
	return user_name + " has opened a door."


func flipped_switch(user_name):
	return user_name + " has flipped a switch."


func picked_up_item(user_name, item_name):
	return user_name + " picked up " + item_name + "."

