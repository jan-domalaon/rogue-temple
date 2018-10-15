# By Jan Domalaon (MaritimesGameworks)

extends Control


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$splash/AnimationPlayer.play("splash_anim")
	set_process_input(true)

func _on_play_button_pressed():
	# Change scene to save scene, where player can choose new game or load a saved game
	get_tree().change_scene("res://game/levels/level_0/test_level.tscn")
	pass

func _on_options_pressed():
	# get_tree().change_scene("res://scenes/menu/options.tscn")
	pass

func _on_quit_button_pressed():
	# Quit the game
	get_tree().quit()
