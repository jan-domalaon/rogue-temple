extends NinePatchRect


signal item_used(slot_name)
signal item_dropped(slot_name)
signal item_unequipped(slot_name)
signal item_equipped(slot_name)

const PRIMARY_DMG_TEXT = "Primary Damage: "
const SECONDARY_DMG_TEXT = "Secondary Damage: "
const SHIELD_TEXT = "Shield HP: "
const ARMOR_TEXT = "Armor Value: "
const FOOD_TEXT = "Nutritional Value: "
const WEAPON_LEVEL_TEXT = "Level Requirement: "

# Current slot in the description
var slot_name


func _ready():
	self.hide()
	get_owner().get_parent().get_parent().connect("inventory_item_select", self, "on_inventory_item_select")
	get_owner().get_parent().get_parent().connect("hide_item_description", self, "on_hide_item_description")


func on_inventory_item_select(item_instance, inv_type):
	self.show()
	# Get details from instance to display
	var item_name
	var tex = get_item_texture(item_instance.find_node("sprite").get_texture())
	var primary_dmg
	var primary_dmg_type
	var secondary_dmg
	var secondary_dmg_type
	if item_instance.is_in_group("items"):
		item_name = item_instance.item_name
	elif item_instance.is_in_group("weapons"):
		item_name = item_instance.weapon_name
		primary_dmg = item_instance.primary_damage
		primary_dmg_type = item_instance.primary_dmg_type
		secondary_dmg = item_instance.secondary_damage
		secondary_dmg_type = item_instance.secondary_dmg_type
	elif item_instance.is_in_group("shields"):
		item_name = item_instance.shield_name
	$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/item_name.set_text(item_name)
	
	# Clear label text
	$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/primary_dmg.set_text("")
	$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/secondary_dmg.set_text("")
	
	
	# Show attributes container
	$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container.show()
	if (item_instance.is_in_group("weapons")):
		# Weapon specific description
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/primary_dmg.set_text(PRIMARY_DMG_TEXT +
		str(primary_dmg) + " " + str(primary_dmg_type))
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/secondary_dmg.set_text(SECONDARY_DMG_TEXT +
		str(secondary_dmg) + " " + str(secondary_dmg_type))
	elif (item_instance.is_in_group("shields")):
		# Show defense value
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/primary_dmg.set_text(SHIELD_TEXT + str(item_instance.shield_hp))
	elif (item_instance.is_in_group("foodstuff")):
		# Show food heal value
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/primary_dmg.set_text(FOOD_TEXT + str(item_instance.food_heal) + " HP")
	elif (item_instance.is_in_group("armor_pieces")):
		# Show armor value
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/primary_dmg.set_text(ARMOR_TEXT + str(item_instance.armor_value))
	else:
		# If this item has no attributes, then hide attributes container
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container.hide()
	$CenterContainer/description_container/NinePatchRect/MarginContainer/item_sprite.set_texture(tex)
	
	reset_buttons()
	
	# Show appropriate buttons based on item type and where item is stored in inventory
	if (inv_type == "equipment"):
		# This item is equipped. Show appropriate buttons (Drop, unequip)
		$CenterContainer/description_container/VBoxContainer/buttons_container/drop_button.show()
		$CenterContainer/description_container/VBoxContainer/buttons_container/unequip_button.show()
	elif (inv_type == "inventory"):
		# For specific items, need to add Use button
		$CenterContainer/description_container/VBoxContainer/buttons_container/drop_button.show()
		if (item_instance.is_in_group("shields") or item_instance.is_in_group("weapons") or item_instance.is_in_group("armor_pieces")):
			# Show equip button for equippable items
			$CenterContainer/description_container/VBoxContainer/buttons_container/equip_button.show()
		if (item_instance.is_in_group("consumables")):
			# Show use button to consume item
			$CenterContainer/description_container/VBoxContainer/buttons_container/use_button.show()
	
	self.slot_name = slot_name
	
	# Free instance to free up memory
	item_instance.queue_free()


func reset_buttons():
	# Reset buttons
	for button in $CenterContainer/description_container/VBoxContainer/buttons_container.get_children():
		button.hide()
	$CenterContainer/description_container/VBoxContainer/throw_button.hide()


func _on_use_button_pressed():
	emit_signal("item_used", self.slot_name)


func _on_drop_button_pressed():
	emit_signal("item_dropped", self.slot_name)


func _on_unequip_button_pressed():
	emit_signal("item_unequipped", self.slot_name)


func _on_equip_button_pressed():
	emit_signal("item_equipped", self.slot_name)


func on_hide_item_description():
	self.hide()


func get_item_texture(tex):
	# Get the first sprite in a sprite's texture
	var tex_subregion = AtlasTexture.new()
	tex_subregion.set_atlas(tex)
	tex_subregion.set_region(Rect2(0, 0, 16, 16))
	return tex_subregion