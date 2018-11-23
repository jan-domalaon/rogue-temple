# By Jan Domalaon
# Game log script. Prints out statements from game_text.gd


extends RichTextLabel


var toggled = false


func _ready():
	# Connect to all nodes that can print a statement
	var printable_nodes = get_tree().get_nodes_in_group("loggable")
	for node in printable_nodes:
		if (node.is_in_group("characters")):
			# Connect character specific signals (dmg)
			node.connect("character_damaged", self, "on_character_damaged")
			# Player specific signals
			if (node.is_in_group("player")):
				node.connect("opened_door", self, "on_opened_door")
			elif (node.is_in_group("mobs")):
				pass
		elif (node.is_in_group("doors")):
			pass
	# Get current level
	
	# Start timer to hide after showing level entering
	$log_hide_timer.start()


func _input(event):
	# Toggle game log appearance
	if (event.is_action_pressed("show_game_log")):
		# If toggled, the game log won't fade. 
		toggled = true if toggled == false else false
		# Turn off timers when not toggled
		if (not toggled):
			$log_hide_timer.stop()
		else:
			# Else, act as usual and start timer.
			$log_hide_timer.start()
		# If transparent, set to opaque, and vice versa
		show_game_log() if modulate == Color(1,1,1,0) else hide_game_log()



func print_text(text, text_color):
	# Append text from game text
	push_color(text_color)
	add_text(text)
	newline()
	
	# Show game log iff not toggled
	if toggled == false:
		show_game_log()
		# Start timer to hide game log
		$log_hide_timer.start()


func on_character_damaged(victim_name, dmg, dmg_type, is_dead):
	# If a character receives damage, print an appropriate statement
	# If dead, change text color
	if (is_dead):
		print_text(game_text.character_damaged(victim_name, dmg, dmg_type, is_dead), game_text.COLOR_KILLED)
	else:
		print_text(game_text.character_damaged(victim_name, dmg, dmg_type, is_dead), game_text.COLOR_DEFAULT)


func on_opened_door(user_name):
	# Print statement for opening door
	print_text(game_text.opened_door(user_name), game_text.COLOR_INTERACT)


func flipped_switch(user_name):
	# Print statement when a switch is flipped
	pass


func on_triggered_trap(victim_name, trap_name):
	# Print statement when a trap is triggered. Just indicate trap name and victim
	pass


func show_game_log():
	# Set transparency to opaque
	self.set_modulate(Color(1,1,1,1))


func hide_game_log():
	# Set to transparent
	self.set_modulate(Color(1,1,1,0))


func _on_log_hide_timer_timeout():
	# Hide game log
	$game_log_animation.play("hide_game_log")
	$log_hide_timer.stop()


func _on_game_log_mouse_entered():
	# Cancel log hide timer and show text
	if (not toggled):
		$log_hide_timer.stop()
		show_game_log()


func _on_game_log_mouse_exited():
	# Start hide timer to hide game log, iff not toggled by player input
	if (not toggled):
		$log_hide_timer.start()
