# By Jan Domalaon

# Level change. Handles calling save and switching to another level

extends Area2D

# File path to next level
export var next_level = ""


func on_level_change():
	print("level changed!")
	# Save game
	save.save_game()
	
	# Load the new level
	get_tree().change_scene(next_level)
