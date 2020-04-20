extends Node

# Options script. Can be accessed by main menu, or pause menu.

var prev_scene = null

func _ready():
	set_process_input(true)
	# Play intro transition (function calls are handled here also)
	$animation_player.play("screen_swipe_open_left")


func disable_menu_buttons(toggle):
	# Disables all buttons that are tagged as options
	for button in get_tree().get_nodes_in_group("option"):
		if toggle:
			button.set_disabled(true)
		else:
			button.set_disabled(false)


func _on_back_pressed():
	# Play close transition and head back to main menu
	get_tree().change_scene("res://menu/main_menu/menu.tscn")


func _on_changelog_pressed():
	# Open the Updates page for game (For now, redirect to github repo)
	OS.shell_open("https://github.com/jan-domalaon/rogue-temple")


func _on_credits_pressed():
	# Switch to credits menu (for now, redirects to README)
	OS.shell_open("https://github.com/jan-domalaon/rogue-temple/blob/master/README.md")


func _on_audio_pressed():
	pass # Replace with function body.


func _on_video_pressed():
	pass # Replace with function body.

