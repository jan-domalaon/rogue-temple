extends Control


signal update_health_bar(health)
signal update_max_health_bar(max_health)


# Get inventory from player
#onready var player_vars = get_node("/root/player_variables")

func _ready():
	set_process_input(true)
	set_process(false)
	# Get level name from player scene
	#get_node('game_level').set_text(get_parent().level_name)
	# Hide appropriate UI elements
	#get_node("inventory").hide()
	#get_node("debug_container").hide()
	# Allow inventory to be selected with rmb
	#get_node("inventory").set_allow_rmb_select(true)

func _input(event):
	# Use event.is_action_pressed() to avoid key repeats
#	if (event.is_action_pressed("access_inventory")):
#		if get_node("inventory").is_visible():
#			get_node("inventory").hide()
#		else:
#			show_inventory()
	if (event.is_action_pressed("access_debug")):
		if get_node("debug_container").is_visible():
			get_node("debug_container").hide()
		else:
			get_node("debug_container").show()

func _process(delta):
	get_node('debug_container/debug_ms').set_text('Movement speed: ' + str(get_parent().move_speed))

#func show_inventory():
#	# Clears inventory (to remove duplicates) and updates current inventory.
#	get_node("inventory").clear()
#	player_vars.inventory.sort()
#	# Array of equipped items
#	var equipped = player_vars.armor_equipped.values() + [player_vars.equipped_weapon, player_vars.spell_tome_equipped]
#	equipped.sort()
#	# Note: Item are just strings
#	# List equipped items first.
#	for items_equipped in equipped:
#		get_node('inventory').add_item(items_equipped + ' (equipped)')
#	# List items that are not equipped.
#	for item in player_vars.inventory:
#		get_node('inventory').add_item(item)
#	print(player_vars.inventory)
#	get_node("inventory").show()
#
#func _on_inventory_focus_enter():
#	# Ignore mouse controls for player.
#	pass # replace with function body\
#
#func _on_inventory_item_rmb_selected( index, atpos ):
#	# Show popup menu at mouse pos and show
#	get_node("inventory/CanvasLayer/inventory_interact").set_position(atpos)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
#	get_node("inventory/CanvasLayer/inventory_interact").show()
#	pass # replace with function body
#
#
#func _on_inventory_interact_item_pressed( ID ):
#	pass # replace with function body
#


func _on_player_max_health_changed(max_health):
	emit_signal("update_max_health_bar", max_health)


func _on_player_health_changed(health):
	emit_signal("update_health_bar", health)
