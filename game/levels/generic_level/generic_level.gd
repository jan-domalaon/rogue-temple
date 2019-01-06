extends Node


export var level_name = "Generic Level"


func _ready():
	# Place player at start pos if the player didn't fall through from the previous level
	if (not pitfall.player_pitfall):
		$player.position = $player_start.position
	# Load data from previous level or save
	if (save.continue_game or save.next_level):
		save.load_game()
	
	# Reset pitfall vars since player didn't fall into a pit (yet >:))
	pitfall.pitfallen_chars = []
	pitfall.player_pitfall = false
