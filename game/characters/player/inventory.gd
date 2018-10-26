# By Jan Domalaon

# Inventory script. Player instances this scene.
# Items are represented as ["item name", "item type"]

extends Node


var inventory_size = 24
var inventory_space = []
var equipment = {"Primary": null, "Secondary": null, "Shield": null, "Helmet": null, 
				"Armor": null, "Gloves": null, "Boots": null}


func _enter_tree():
	# Get all items when the player enters the tree
	# For now, the items are hard coded
	equipment["Primary"] = ["Iron Mace", "WEAPON"]
	equipment["Secondary"] = ["Ranger Bow", "WEAPON"]
	equipment["Shield"] = ["Iron Shield", "SHIELD"]
	equipment["Helmet"] = ["Bucket Helm", "HELMET"]
	equipment["Armor"] = ["Chainmail Armor", "ARMOR"]
	equipment["Gloves"] = ["Chainmail Gloves", "GLOVES"]
	equipment["Boots"] = ["Leather Boots", "BOOTS"]
	
	# Add items to inventory space
	inventory_space = create_inventory_space(inventory_size)


func _ready():
	pass


func _input(event):
	# Open inventory UI
	if (event.is_action_pressed("open_inventory")):
		$CanvasLayer/inventory_hud.show() if not $CanvasLayer/inventory_hud.is_visible_in_tree() else $CanvasLayer/inventory_hud.hide()


#
# Inventory backend functions
#
func create_inventory_space(size):
	# Creates an empty inventory
	var space = []
	for i in range(size):
		space.append(null)
	return space


func equip(slot, item):
	# Equip an item to an equipment slot
	# Unequip current equipment slot, if there's an item in that slot
	if (equipment[slot] != ""):
		unequip(slot)
	# Equip desired item to slot
	equipment[slot] = item


func unequip(slot):
	#  (str) -> null
	var i = 0
	var full_inv = true
	for i in inventory_space.size():
		if (inventory_space[i] == ""):
			# Place item in slot to inventory space
			inventory_space[i] = equipment[slot]
			equipment[slot] = ""
			full_inv = false
	if (full_inv):
		# Drop the item to the ground
		drop_item(equipment[slot])
		equipment[slot] = ""


func drop_item(item):
	# Meant to place item in the world
	# Look for item's item_name in item_type's list
	# Resource path for item
	var to_drop  = get_node("/root/item_db").get(item[1].to_upper())[item[0]]
	# Add item to world
	var load_item = load(to_drop)
	var item_instance = load_item.instance()
	get_node("../..").add_child(item_instance)
	item_instance.position = get_parent().get_global_position()


func pickup_item(item_node):
	# Add item to inventory
	# Add item according to inventory form
	var inventory_slot = [item_node.item_name, item_node.item_type]
	for i in range(inventory_space.size()):
		if (inventory_space[i] == null):
			# Place item in that slot and stop looking for an empty slot.
			inventory_space[i] = inventory_slot
			# Remove item from the world
			item_node.queue_free()
			print("inventory: " + str(inventory_space))
			break


func get_armor_value():
	# Gets the armor value. To be retrieved by player
	var armor_value = 0
	# Instance all armor pieces and get its armor value. Queue_free after
	return armor_value


func swap_weapon():
	# Swap primary to secondary
	var primary = equipment["Primary"]
	equipment["Primary"] = equipment["Secondary"]
	equipment["Secondary"] = primary


#
# Inventory UI functions
#
func display_equipment():
	emit_signal("")


func display_slot(slot, item):
	