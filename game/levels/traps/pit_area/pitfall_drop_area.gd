# Area where the player drops into. Choose a random position within the area for the player to start in.


extends Area2D


func _ready():
	# Get extents of drop area
	var center_pos = $drop_area_shape.position + $".".position
	var drop_area_extents = $drop_area_shape.shape.extents
	
	# Get all characters in pitfall list and place them on random positions in the area
	for char_filepath in pitfall.pitfallen_chars:
		if (char_filepath != "res://game/characters/player/player.tscn"):
			# Instance every character in pitfallen character
			var char_instance = load(char_filepath).instance()
			
			# Choose a random position within the drop area
			char_instance.position.x = fmod(randi(), drop_area_extents.x) - (drop_area_extents.x/2) + (center_pos.x)
			char_instance.position.y = fmod(randi(), drop_area_extents.y) - (drop_area_extents.y/2) + (center_pos.y)
			
			# Cut HP to half. Shows they dropped into the pit.
			char_instance.health = char_instance.health / 2
			
			# Add instance to scene
			add_child(char_instance)
		else:
			# This node is the player. Only move player to drop position as it is already in the level
			get_parent().get_parent().get_node("player").position.x = fmod(randi(), drop_area_extents.x) - (drop_area_extents.x/2) + (center_pos.x)
			get_parent().get_parent().get_node("player").position.y = fmod(randi(), drop_area_extents.y) - (drop_area_extents.y/2) + (center_pos.y)
			
			# Cut player HP to half. If it's at 1, keep at 1
			if get_parent().get_parent().get_node("player").health > 1:
				print("player health into pit. health > 1")
				get_parent().get_parent().get_node("player").health = get_parent().get_parent().get_node("player").health / 2
			else:
				get_parent().get_parent().get_node("player").health = 1
		# Level change is in charge of clearing pitfall global vars
