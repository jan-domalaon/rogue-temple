# By Jan Domalaon (MaritimesGameworks)

extends Container

func _on_new_game_pressed():
	# Go to build scene
	# For now, switch to first level.
	get_tree().change_scene('res://game/levels/level_0/test_level.tscn')


func _on_load_pressed():
	# Call global.gd to load game
	pass # replace with function body

