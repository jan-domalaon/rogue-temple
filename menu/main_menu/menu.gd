# By Jan Domalaon (MaritimesGameworks)


extends CanvasLayer

export var version_name = "Test Build #1"


func _ready():
	# Connect to signal when animation is finished
	# Play menu button animation
	#$AnimationPlayer.play("switch_screen_anim")
	set_process_input(true)
	
	# Update version name
	$TestLabel.set_text(version_name)


func _on_play_button_pressed():
	SceneChangeTransition.change_scene_transition("res://menu/save_menu/save_screen.tscn", $CenterContainer/menu_button_container)


func _on_options_pressed():
	SceneChangeTransition.change_scene_transition("res://menu/options/options.tscn", $CenterContainer/menu_button_container)


func _on_quit_button_pressed():
	# Quit the game
	get_tree().quit()
