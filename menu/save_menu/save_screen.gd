# By Jan Domalaon (MaritimesGameworks)

extends Container


func _ready():
	# Reset the continue_game flag in save singleton
	save.continue_game = false


func _on_new_game_pressed():
	# Go to build scene
	# For now, switch to first level.
	get_tree().change_scene('res://game/levels/level_0/test_level.tscn')


func _on_load_pressed():
	# Tell level to load game, rather than make a new game
	save.continue_game = true
	
	# Load game based on the current level in the save

