extends Node


export (String) var level_name = "Generic Level"
export (bool) var terminal_level = false

# Game log signals
signal player_pitfallen_drop
signal level_welcome(level_name)
signal show_debug


func _ready():
	# Print out level name on game log
	emit_signal("level_welcome", level_name)
	
	# Load data from previous level or save
	if (save.continue_game or save.next_level):
		save.load_game()
	# Place player at start pos if the player didn't fall through from the previous level
	if (not pitfall.player_pitfall):
		$player.position = $player_start.position
	else:
		# The player fell through the pit. Emit game log message
		emit_signal("player_pitfallen_drop")
		# The player position will be determined by pitfall_drop_area.gd
		# Handle player health
		if ($player.health > 1):
			$player.receive_phys_damage(($player.health / 2), "x")
		elif ($player.health <= 1):
			$player.health = 1
		
	# Reset pitfall vars since player didn't fall into a pit (yet >:))
	pitfall.pitfallen_chars = []
	pitfall.player_pitfall = false
	
	# If this level is a terminal level (ie last level), delete any level exits
	$level_change_container.queue_free()


func _input(event):
	# Check for key input for debug view
	if (event.is_action_pressed("access_debug")):
		emit_signal("show_debug")
