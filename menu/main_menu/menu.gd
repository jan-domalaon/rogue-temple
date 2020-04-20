# By Jan Domalaon (MaritimesGameworks)


extends Control

export var version_name = "Test Build #1"


func _ready():
	# Connect to signal when animation is finished
	# Play menu button animation
	$AnimationPlayer.play("switch_screen_anim")
	set_process_input(true)
	
	# Update version name
	$TestLabel.set_text(version_name)

func _on_play_button_pressed():
	switch_screens("switch_screen_anim", "res://menu/save_menu/save_screen.tscn")


func _on_options_pressed():
	switch_screens("screen_swipe", "res://menu/options/options.tscn")


func _on_quit_button_pressed():
	# Quit the game
	get_tree().quit()


func switch_screens(anim, scene_path):
	# Disable menu buttons to prevent triggering other scene changes
	disable_menu_buttons()
	
	# Play screen animation defined.
	# If using switch_screen_anim, play backwards. 
	# If using mask transition, turn on visibility
	if (anim == "switch_screen_anim"):
		$AnimationPlayer.play_backwards(anim)
	elif (anim == "screen_swipe"):
		$menu_transition.show()
		$AnimationPlayer.play(anim)
	# Once animation is done, change scenes
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(scene_path)


func disable_menu_buttons():
	# Disables all buttons in the menu
	for button in $CenterContainer/menu_button_container.get_children():
		button.set_disabled(true)
