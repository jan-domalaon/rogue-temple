# By Jan Domalaon

# Inventory script. Player instances this scene.
# Items are represented as ["item name", "item type"]

extends Node


var inventory_size = 12
var inventory_space = []
var equipment = {"Primary Weapon": "", "Secondary Weapon": "", "Shield": "", "Helmet": "", 
				"Armor": "", "Gloves": "", "Boots": ""}


func equip(slot, item):
	# Equip an item to an equipment slot
	# Unequip current equipment slot
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
	if (inventory_space.size() < inventory_size):
		inventory_space.append(inventory_slot)
		# Remove item from the world
		item_node.queue_free()