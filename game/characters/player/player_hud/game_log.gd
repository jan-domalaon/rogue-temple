# By Jan Domalaon
# Game log script. Prints out statements from game_text.gd


extends RichTextLabel


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
	

func print_text(text, text_color):
	# Append text from game text
	push_color(text_color)
	add_text(text)
	newline()


func on_character_damaged(victim_name, dmg, dmg_type, is_dead):
	# If a character receives damage, print an appropriate statement
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