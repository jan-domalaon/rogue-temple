# Handles game saves and loading
# See "Save system Godot Tutorial" by GDquest


extends Node


const SAVE_PATH = "res://game/saves/save.json"
# The player can load a save two ways: by loading from the main menu, or by changing levels (level changes trigger saves)
# Variable to tell if the level should load game
export var continue_game = false
# Indicates that player is changing level
export var next_level = false


func save_game():
	# Get the save data from all persistent characters
	var save_dict = {}
	var persistent_nodes = get_tree().get_nodes_in_group("persistent")
	for node in persistent_nodes:
		save_dict[node.get_name()] = node.save_data()
	
	# Create save directory if not created already
	var save_dir = Directory.new()
	if not save_dir.dir_exists("user://game/saves"):
		save_dir.make_dir("user://game/saves")
	
	# Create save file
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	
	# Serialize data and store into save file. Close file
	save_file.store_line(to_json(save_dict))
	save_file.close()


func load_game():
	# Try loading a save file
	var save_file = File.new()
	if save_file.file_exists(SAVE_PATH):
		# Parse data
		save_file.open(SAVE_PATH, File.READ)
		var data_dict = {}
		data_dict = parse_json(save_file.get_as_text())
		
		# Load the data into persistent nodes
		for node_path in data_dict.keys():
			# Load nodes that aren't data
			if (node_path != "inventory"):
				get_tree().get_current_scene().find_node(str(node_path)).load_data(data_dict[node_path])
	
	# Close file
	save_file.close()


func load_inventory():
	# To be called by inventory.gd when inventory is ready.
	# Try loading a save file
	var save_file = File.new()
	if save_file.file_exists(SAVE_PATH):
		# Parse data
		save_file.open(SAVE_PATH, File.READ)
		var data_dict = {}
		data_dict = parse_json(save_file.get_as_text())
		
		# Load inventory
		get_tree().get_current_scene().find_node("inventory").load_inventory_data(data_dict["inventory"])
	
	# Close file
	save_file.close()


func get_game_level():
	# For continuing game, load the game level filepath saved on save.json
	var game_level_filepath
	# Try loading a save file
	var save_file = File.new()
	if save_file.file_exists(SAVE_PATH):
		# Parse data
		save_file.open(SAVE_PATH, File.READ)
		var data_dict = {}
		data_dict = parse_json(save_file.get_as_text())
		
		# Get the game level from player node
		game_level_filepath = data_dict["player"].next_level_filepath
	# Close file
	save_file.close()
	# Return game level
	return game_level_filepath


func clear_save():
	var dir = Directory.new()
	dir.remove(SAVE_PATH)


func save_file_exists():
	var save_file = File.new()
	return save_file.file_exists(SAVE_PATH)
