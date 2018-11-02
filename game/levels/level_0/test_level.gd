# By Jan Domalaon

# Level script. Handles loading game


extends Node

func _ready():
	save.load_game()
	
	# Place player at start pos
	$player.position = $player_start.position