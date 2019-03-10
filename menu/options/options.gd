extends Node

# Options script. Can be accessed by main menu, or pause menu.

var prev_scene = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_back_pressed():
	get_tree().change_scene("res://menu/main_menu/menu.tscn")

