# By Jan Domalaon (MaritimesGameworks)

extends Control

export (String) var new_game_level = 'res://game/levels/level_0/prototype_level_intro.tscn'


func _ready():
	# Reset the continue_game flag in save singleton
	save.continue_game = false
	
	# Toggle load menu only when a save is present. Clear tooltip
	if save.save_file_exists():
		$margin_container/new_game_cont/load.set_disabled(false)
		$margin_container/new_game_cont/load.set_tooltip("")
	
	# Connect every button to trigger transition
	for button in get_tree().get_nodes_in_group("option"):
		button.connect("pressed", self, "on_any_button_pressed")


func _on_new_game_pressed():
	# In the future, there might be a build_screen before a new_level
	# For now, load level and clear previous save
	save.clear_save()
	$animation_player.play("screen_swipe")
	yield($animation_player, "animation_finished")
	get_tree().change_scene(new_game_level)


func _on_load_pressed():
	# Load a previous save
	save.continue_game = true
	# Get the player's current game level from the save
	if save.save_file_exists():
		$animation_player.play("screen_swipe")
		yield($animation_player, "animation_finished")
		var current_level_filepath = save.get_game_level()
		get_tree().change_scene(current_level_filepath)
	else:
		print("Save file doesn't exist!")
