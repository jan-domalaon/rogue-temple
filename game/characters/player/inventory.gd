# By Jan Domalaon

# Inventory script. Player instances this scene.
# Items are represented as ["item name", "item type"]

extends Node


# Signals for updating inventory UI
signal update_slot_tex(texture, slot_name)
signal inventory_item_select(item_name, primary_dmg, primary_dmg_type, secondary_dmg, secondary_dmg_type, tex, type, slot_name)
signal hide_item_description


const EQUIPMENT_SLOTS = ["Primary", "Secondary", "Shield", "Helmet", "Armor", "Gloves", "Boots"]

var inventory_size = 24
var inventory_space = []
var equipment = {"Primary": null, "Secondary": null, "Shield": null, "Helmet": null, 
				"Armor": null, "Gloves": null, "Boots": null}
var selected_slot
# Equips the player once
onready var equipped_weaponry = false


func _enter_tree():
	# Create the inventory space array
	inventory_space = create_inventory_space(inventory_size)


func _ready():
	# If this is a new game, load a build
	if (not (save.continue_game or save.next_level)):
		# Create inventory_space from builds.
		for i in range(inventory_size):
			if (i <= builds.get(builds.chosen_build)["Inventory Space"].size() - 1):
				inventory_space[i] = builds.get(builds.chosen_build)["Inventory Space"][i]
			else:
				inventory_space[i] = null
		# Copy equipment from builds to player's inventory equipment
		equipment = builds.get(builds.chosen_build)["Equipment"]
	# Else, the player is switching levels or continuing from a previous save
	elif (save.continue_game or save.next_level):
		# Load inventory from the save
		save.load_inventory()
	print("inventory space: " + str(inventory_space))
	
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
		elif button.function == "Use":
			button.connect("interact_inventory", self, "on_item_used")


func _input(event):
	# Open inventory UI
	if (event.is_action_pressed("open_inventory")):
		if not ($CanvasLayer/inventory_hud.modulate == Color(1,1,1,1)):
			get_tree().paused = true
			# Play inventory open animation, stop any animationss if running
			$inventory_animation_player.stop()
			$inventory_animation_player.play("inventory_open")
			# Disable player input
			get_parent().set_process_input(false)
		else:
			# $CanvasLayer/inventory_hud.hide()
			get_tree().paused = false
			# Play inventory open animation backwards, stop any animations if running
			$inventory_animation_player.stop()
			$inventory_animation_player.play_backwards("inventory_open")
			# Enable player input
			get_parent().set_process_input(true)


#
# Inventory backend functions
#
func create_inventory_space(size):
	# Creates an empty inventory
	var space = []
	for i in range(size):
		space.append(null)
	return space


func equip(slot_name):
	# Equip an item to an equipment slot
	# Instance item to get the right slot to put in
	var inventory_item = inventory_space[int(slot_name)]
	var item_instance = instance_item(inventory_item)
	
	# Check if the player meets the equipment's level requirement. Only equip if >= level req
	if (get_parent().player_level >= item_instance.level_req):
		# Determine whether armor or weapon
		var equipment_slot
		if item_instance.is_in_group("armor_pieces"):
			# Get appropriate armor piece type (gloves, boots, etc) for equipment slot
			equipment_slot = item_instance.get("item_type").capitalize()
		elif item_instance.is_in_group("shields"):
			equipment_slot = "Shield"
		else:
			# This item is a weapon. Put in secondary slot.
			equipment_slot = "Secondary"
		
		# Unequip current equipment slot, if there's an item in that slot
		if (equipment[equipment_slot] != null):
			unequip(equipment_slot)
		# Equip desired item to slot
		equipment[equipment_slot] = inventory_item
		# Remove item from inventory_space
		inventory_space[int(slot_name)] = null
		# Update UI and update player
		update_inventory_ui()
		return true
	else:
		# Emit signal for displaying level locked message
		emit_signal("equipment_level_locked_from_player")
		print("player level lower than equipment level requirement!")
		return false


func unequip(slot_name):
	#  (str) -> null
	var i = 0
	var full_inv = true
	# Check if this item is a primary
	var can_drop = primary_unequipped(slot_name)
	# If primary weapon, use secondary as primary
	if (can_drop):
		# Put unequipped item into inventory space
		for i in inventory_space.size():
			if (inventory_space[i] == null):
				# Place item in slot to inventory space
				inventory_space[i] = equipment[slot_name]
				equipment[slot_name] = null
				full_inv = false
		# Else, drop the item
		if (full_inv):
			# Drop the item to the ground
			drop_item(equipment[slot_name])
			equipment[slot_name] = null
		if (slot_name == "Primary"):
			equipment["Primary"] = equipment["Secondary"]
			equipment["Secondary"] = null
		update_inventory_ui()


func drop_item(slot_name):
	# Meant to place item in the world
	# Look for item's item_name in item_type's list
	# Resource path for item
	var item
	# Case where slot selected is the primary weapon
	var can_drop = primary_unequipped(slot_name)
	if (can_drop):
		if slot_name in EQUIPMENT_SLOTS:
			item = equipment[slot_name]
			# Clear item from equipment
			equipment[slot_name] = null
		else:
			item = inventory_space[int(slot_name)] 
			# Clear item from inventory
			inventory_space[int(slot_name)] = null
		var to_drop  = get_node("/root/item_db").get(item[1].to_upper())[item[0]]
		# Add item to world
		var load_item = load(to_drop)
		var item_instance = load_item.instance()
		
		# Add to item container of level
		get_node("../../item_container").add_child(item_instance)
		
		# If item instance is a weapon or shield, turn on interact shape
		if (item_instance.is_in_group("weapons") or item_instance.is_in_group("shields")):
			item_instance.get_node("interact_area/interact_shape").set_disabled(false)
			# Indicate that this equipment is a dropped item
			item_instance.dropped_item = true
			# Set scale according to what type of equipment
			if (item_instance.is_in_group("weapons")):
				item_instance.set_scale(Vector2(0.5, 0.5))
			elif (item_instance.is_in_group("shields")):
				item_instance.set_scale(Vector2(0.75, 0.75))
		
		# Set item instance on player's position
		item_instance.position = get_parent().get_global_position()
		
		# Use secondary weapon as primary if this slot is primary
		if (slot_name == "Primary"):
			equipment["Primary"] = equipment["Secondary"]
			equipment["Secondary"] = null
			
		update_inventory_ui()


func pickup_item(item_node):
	# Add item to inventory
	# Add item according to inventory form
	var new_item = item_node
	var inventory_slot
	# Special case where item is a dropped weapon
	if (item_node.is_in_group("dropped_weapons")):
		# The node wanted is the parent node, not the interact_area of the weapon
		new_item = item_node.get_parent()
		inventory_slot = [new_item.weapon_name, "WEAPON"]
	elif (item_node.is_in_group("dropped_shields")):
		new_item = item_node.get_parent()
		inventory_slot = [new_item.shield_name, "SHIELD"]
	else:
		inventory_slot = [new_item.item_name, new_item.item_type]
	for i in range(inventory_space.size()):
		if (inventory_space[i] == null):
			# Place item in that slot and stop looking for an empty slot.
			inventory_space[i] = inventory_slot
			# Remove item from the world
			new_item.queue_free()
			# Update UI
			update_slot_tex(new_item, str(i))
			#print("inventory: " + str(inventory_space))
			break


func get_armor_value():
	# Gets the armor value. To be retrieved by player
	# Instance all armor pieces and get its armor value. Queue_free after
	var armor_value = 0
	if (equipment["Helmet"] != null):
		var helmet = instance_item(equipment["Helmet"])
		armor_value = armor_value + helmet.get("armor_value")
		helmet.queue_free()
	if (equipment["Armor"] != null):
		var armor = instance_item(equipment["Armor"])
		armor_value = armor_value + armor.get("armor_value")
		armor.queue_free()
	if (equipment["Boots"] != null):
		var boots = instance_item(equipment["Boots"])
		armor_value = armor_value + boots.get("armor_value")
		boots.queue_free()
	if (equipment["Gloves"] != null):
		var gloves = instance_item(equipment["Gloves"])
		armor_value = armor_value + gloves.get("armor_value")
		gloves.queue_free()
	return armor_value


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
	# Instance item given by inventory
	var item = inventory_space[int(selected_slot)]
	var item_instance = instance_item(item)
	# If consumable, consume item
	if (item_instance.is_in_group("consumables")):
		# Item's effects goes to the player
		# If food, check if it can be consumed
		if (item_instance.can_consume(get_parent())):
			item_instance.consume(get_parent())
			# Clear selected slot
			inventory_space[int(selected_slot)] = null
			item_instance.queue_free()
			# Hide item_description box (to prevent player inputs)
			emit_signal("hide_item_description")
			# Update inventory space textures
			display_inventory_space()
		else:
			print("player is still at full health! can't eat!")


func on_item_dropped():
	print("dropping item!")
	drop_item(selected_slot)
	get_parent().reset_weaponry()
	get_parent().get_weaponry(false)
	if (selected_slot == "Shield"):
		get_parent().reset_shield()
	get_parent().armor = get_armor_value()


func on_item_unequipped():
	print("unequipping item!")
	unequip(selected_slot)
	get_parent().reset_weaponry()
	get_parent().get_weaponry(false)
	if (selected_slot == "Shield"):
		get_parent().reset_shield()
	get_parent().armor = get_armor_value()


func on_item_equipped():
	if (equip(selected_slot)):
		print("equipping item!")
		# Add weaponry nodes to player
		get_parent().reset_weaponry()
		get_parent().get_weaponry(false)
		# Add shield nodes to player
		get_parent().reset_shield()
		get_parent().get_shield(false)
		# Reset armor value of player
		get_parent().armor = get_armor_value()


func primary_unequipped(slot_name):
	# Case where primary weapon is unequipped or dropped
	var can_drop = true
	if (slot_name == "Primary" and equipment["Secondary"] == null):
		can_drop = false
	return can_drop


#
# Inventory UI functions
#
func update_slot_tex(instance, slot_name):
	# If null, then there's no instance. Null texture
	if instance == null:
		emit_signal("update_slot_tex", null, slot_name)
	else:
		emit_signal("update_slot_tex", instance.find_node("sprite").get_texture(), slot_name)
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


func update_inventory_ui():
	# Update the textures in the inventory. Called when backend is changed
	display_equipment()
	display_inventory_space()
	# Hide the item description box (to reset)
	emit_signal("hide_item_description")


func on_item_slot_selected(item_slot):
	var slot_name = item_slot.capitalize()
	# Put info into item description box
	# Slot name is either in equipment or in inventory space
	var item_instance
	var inv_type
	var item
	
	# Selected slot is the item slot given
	selected_slot = slot_name
	
	# Get item in inventory or equipment
	if (slot_name in EQUIPMENT_SLOTS):
		item = equipment[slot_name]
	else:
		item = inventory_space[int(slot_name)]
	
	# Run this only if the slot selected is not null
	if item != null:
		if (slot_name in EQUIPMENT_SLOTS):
			item_instance = instance_item(equipment[slot_name])
			inv_type = "equipment"
		else:
			item_instance = instance_item(inventory_space[int(slot_name)])
			inv_type = "inventory"
		# Give details to inventory UI
		emit_signal("inventory_item_select", item_instance, inv_type)


func get_item_texture(tex):
	# Get the first sprite in a sprite's texture
	var tex_subregion = AtlasTexture.new()
	tex_subregion.set_atlas(tex)
	tex_subregion.set_region(Rect2(0, 0, 16, 16))
	return tex_subregion


func save_data():
	# Save inventory: items in inventory space, and items in equipment
	var save_dict = {
		inventory_space = inventory_space,
		equipment_space = equipment
	}
	return save_dict


func load_inventory_data(dict):
	inventory_space = dict["inventory_space"]
	equipment = dict["equipment_space"]

