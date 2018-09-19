# By Jan Domalaon (MaritimesGameworks)

extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_new_game_pressed():
	# Go to build scene
	# For now, switch to first level.
	get_tree().change_scene('res://scenes/test/training_level_0.tscn')


func _on_load_pressed():
	# Call global.gd to load game
	pass # replace with function body

