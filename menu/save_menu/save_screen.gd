# By Jan Domalaon (MaritimesGameworks)

extends Container


func _ready():
	# Reset the continue_game flag in save singleton
	save.continue_game = false


func _on_new_game_pressed():
	# In the future, there might be a build_screen before a new_level
	# For now, load level and clear previous save
	save.clear_save()
	get_tree().change_scene('res://game/levels/level_0/test_level.tscn')
	


func _on_load_pressed():
	# Load a previous save
	save.continue_game = true
	get_tree().change_scene('res://game/levels/level_0/test_level.tscn')

