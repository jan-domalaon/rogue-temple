# By Jan Domalaon (MaritimesGameworks)

extends Node

# Intro scene. Fades to menu scene.

func _ready():
	set_process_input(true)

func _input(event):
	# Skip instantly to main menu
	if (event.is_pressed()):
		get_tree().change_scene("res://menu/main_menu/menu.tscn")

func _on_intro_finished():
	# Change to main menu when intro is finished
	get_tree().change_scene("res://menu/main_menu/menu.tscn")

