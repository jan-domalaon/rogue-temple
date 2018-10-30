# By Jan Domalaon

# Inventory script. Player instances this scene.
# Items are represented as ["item name", "item type"]

extends Node


# Signals for updating inventory UI
signal update_slot_tex(texture, slot_name)
signal inventory_item_select(item_name, primary_dmg, primary_dmg_type, secondary_dmg, secondary_dmg_type, tex, type, slot_name)

const EQUIPMENT_SLOTS = ["Primary", "Secondary", "Shield", "Helmet", "Armor", "Gloves", "Boots"]

var inventory_size = 24
var inventory_space = []
var equipment = {"Primary": null, "Secondary": null, "Shield": null, "Helmet": null, 
				"Armor": null, "Gloves": null, "Boots": null}
var selected_slot


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
	# Update the inventory's item textures
	display_equipment()
	display_inventory_space()
	
	# Connect to inventory UI item slots
	for button in get_tree().get_nodes_in_group("inventory_slots"):
		button.connect("item_selected", self, "on_item_slot_selected")
	
	# Connect to inventory interaction buttons
	for button in get_tree().get_nodes_in_group("inv_interact_buttons"):
#		if button.get_name() == "use_button":
#			button.connect("item_used", self, "on_item_used")
		if button.function == "Unequip":
			button.connect("interact_inventory", self, "on_item_unequipped")
		elif button.function == "Equip":
			button.connect("interact_inventory", self, "on_item_equipped")
		elif button.function == "Drop":
			button.connect("interact_inventory", self, "on_item_dropped")


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
			# Update UI
			update_slot_tex(item_node, str(i))
			print("inventory: " + str(inventory_space))
			break


func get_armor_value():
	# Gets the armor value. To be retrieved by player
	# Instance all armor pieces and get its armor value. Queue_free after
	var helmet = instance_item(equipment["Helmet"])
	var armor = instance_item(equipment["Armor"])
	var boots = instance_item(equipment["Boots"])
	var gloves = instance_item(equipment["Gloves"])
	return helmet.get("armor_value") + armor.get("armor_value") + boots.get("armor_value") + gloves.get("armor_value")
	helmet.queue_free()
	armor.queue_free()
	boots.queue_free()
	gloves.queue_free()


func swap_weapon():
	# Swap primary to secondary
	var primary = equipment["Primary"]
	equipment["Primary"] = equipment["Secondary"]
	equipment["Secondary"] = primary
	
	# Update equipment UI
	display_equipment()


func instance_item(item):
	var item_path = item_db.get(item[1])[item[0]]
	var item_load = load(item_path)
	return item_load.instance()


func on_item_used():
	# To be added when potions and foodstuff are implemented
	pass

func on_item_dropped():
	var item
	if (selected_slot in EQUIPMENT_SLOTS):
		item = equipment[selected_slot]
	else:
		item = inventory_space[int(selected_slot)]
	print("dropping item!")
	drop_item(item)


func on_item_unequipped():
	pass

func on_item_equipped():
	pass


func instance_in_item_space(slot_name):
	var instanced_item
	# Return the correct item instance given a slot name
	if (slot_name in EQUIPMENT_SLOTS):
		instanced_item = equipment[slot_name]
	else:
		instanced_item = inventory_space[int(slot_name)]
	return instanced_item

#
# Inventory UI functions
#
func update_slot_tex(instance, slot_name):
	# If null, then there's no instance. Null texture
	if instance == null:
		emit_signal("update_slot_tex", null, slot_name)
	else:
		emit_signal("update_slot_tex", instance.get_node("sprite").get_texture(), slot_name)
		# Queue instance free
		instance.queue_free()


func display_equipment():
	# Update all textures in equipment. Ftn to be called when starting inventory
	for key in equipment.keys():
		if (equipment[key] != null):
			# Instance, get texture, send to UI
			# Item path: item_db.item_type[item_name]
			var item = equipment[key]
			var item_path = item_db.get(item[1])[item[0]]
			var item_load = load(item_path)
			var item_instance = item_load.instance()
			# Pass equipment key as the slot name
			update_slot_tex(item_instance, key)
		else:
			# There is no item here. No texture in slot
			update_slot_tex(null, key)


func display_inventory_space():
	# Display all items in the inventory space
	for i in inventory_space.size():
		if (inventory_space[i] != null):
			var item = inventory_space[i]
			var item_path = item_db.get(item[1])[item[0]]
			var item_load = load(item_path)
			var item_instance = item_load.instance()
			# Pass instance and index as the slot name
			update_slot_tex(item_instance, str(i))
		else:
			update_slot_tex(null, str(i))


func on_item_slot_selected(item_slot):
	var slot_name = item_slot.capitalize()
	# Put info into item description box
	# Slot name is either in equipment or in inventory space
	var item_instance
	var inv_type
	# Selected slot is the item slot given
	selected_slot = slot_name
	if (slot_name in EQUIPMENT_SLOTS):
		item_instance = instance_item(equipment[slot_name])
		inv_type = "equipment"
	else:
		item_instance = instance_item(inventory_space[int(slot_name)])
		inv_type = "inventory"
	
	var item_texture = get_item_texture(item_instance.get_node("sprite").get_texture())
	# Give details to inventory UI
	if item_instance.is_in_group("weapons"):
		emit_signal("inventory_item_select", item_instance.weapon_name, item_instance.primary_damage, item_instance.primary_dmg_type,
		item_instance.secondary_damage, item_instance.secondary_dmg_type, item_texture, inv_type, slot_name)
	elif item_instance.is_in_group("shields"):
		emit_signal("inventory_item_select", item_instance.shield_name, null, null, null, null, item_texture, inv_type, slot_name)
	else:
		emit_signal("inventory_item_select", item_instance.item_name, null, null, null, null, item_texture, inv_type, slot_name)
	item_instance.queue_free()


func get_item_texture(tex):
	# Get the first sprite in a sprite's texture
	var tex_subregion = AtlasTexture.new()
	tex_subregion.set_atlas(tex)
	tex_subregion.set_region(Rect2(0, 0, 16, 16))
	return tex_subregion