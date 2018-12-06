extends Node


export var level_name = "Generic Level"


func _ready():
	# Place player at start pos
	$player.position = $player_start.position
	# Give player the current game level file path used for loading new levels
	$player.current_game_level = filename
	# Load data from previous level or save
	if (save.continue_game or save.next_level):
		save.load_game()
