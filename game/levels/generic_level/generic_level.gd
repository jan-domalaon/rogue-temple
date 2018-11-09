extends Node

func _ready():
	# Load game with player data from previous level
	save.load_game()
	
	# Load player
	var player = preload("res://game/characters/player/test_player.tscn").instance()
	player.position = $player_start.position
	add_child(player)
