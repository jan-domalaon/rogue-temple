# By Jan Domalaon

# Inventory script. Player instances this scene.

extends Node


var inventory_space = []
var equipment = {"Primary Weapon": "", "Secondary Weapon": "", "Shield": "", "Helmet": "", 
				"Armor": "", "Gloves": "", "Boots": ""}


func _ready():
	pass


func equip(slot, item):
	# Unequip current equipment slot
	unequip(slot)
	# Equip desired item to slot
	equipment[slot] = item


func unequip(slot):
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
	pass