extends Node


func _ready():
	# Place player at start pos
	$player.position = $player_start.position
	# Load data from previous level or save
	if (save.continue_game or save.next_level):
		save.load_game()
	pass
