# By Jan Domalaon (MaritimesGameworks)

extends Node

# This script will handle the level switching, game saving, and loading saves.

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_level_change():
	print('on level change')

func save():
	# Save nodes with 'Persist' group
	# Also save player variables from player_variables.gd
	# Save build given
	pass

func save_game():
	pass

func load_game():
	# If file does not exist, this does not run.
	# Parse through save
	pass
