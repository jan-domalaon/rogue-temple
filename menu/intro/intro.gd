# By Jan Domalaon (MaritimesGameworks)

extends Node

# Intro scene. Fades to menu scene.

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)

func _input(event):
	if (event.is_pressed()):
		get_tree().change_scene("res://menu/main_menu/menu.tscn")

func _on_intro_finished():
	get_tree().change_scene("res://menu/main_menu/menu.tscn")

