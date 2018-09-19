extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# Path to next level
export var next_level = ''

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# Get signal from player when he/she is changing levels\
	pass

func _on_level_change():
	# Change scene to next level
	get_tree().change_scene(next_level)

