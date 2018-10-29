extends NinePatchRect

const PRIMARY_DMG_TEXT = "Primary Damage: "
const SECONDARY_DMG_TEXT = "Secondary Damage: "


func _ready():
	self.hide()
	get_owner().get_parent().get_parent().connect("inventory_item_select", self, "on_inventory_item_select")


func on_inventory_item_select(item_name, primary_dmg, primary_dmg_type, secondary_dmg, secondary_dmg_type, tex, type):
	self.show()
	$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/item_name.set_text(item_name)
	if (primary_dmg == null):
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container.hide()
	else:
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container.show()
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/primary_dmg.set_text(PRIMARY_DMG_TEXT +
		str(primary_dmg) + " " + str(primary_dmg_type))
		$CenterContainer/description_container/VBoxContainer/CenterContainer/item_text/attributes_container/secondary_dmg.set_text(SECONDARY_DMG_TEXT +
		str(secondary_dmg) + " " + str(secondary_dmg_type))
	$CenterContainer/description_container/NinePatchRect/MarginContainer/item_sprite.set_texture(tex)
	
	reset_buttons()
	
	if (type == "equipment"):
		# This item is equipped. Show appropriate buttons (Drop, unequip)
		$CenterContainer/description_container/VBoxContainer/buttons_container/drop_button.show()
		$CenterContainer/description_container/VBoxContainer/buttons_container/unequip_button.show()
	elif (type == "inventory"):
		# For now, equip, drop
		# For specific items, need to add Use button
		$CenterContainer/description_container/VBoxContainer/buttons_container/drop_button.show()
		$CenterContainer/description_container/VBoxContainer/buttons_container/equip_button.show()


func reset_buttons():
	# Reset buttons
	for button in $CenterContainer/description_container/VBoxContainer/buttons_container.get_children():
		button.hide()
	$CenterContainer/description_container/VBoxContainer/throw_button.hide()



func _on_use_button_pressed():
	pass # replace with function body


func _on_drop_button_pressed():
	emit_signal("item_dropped")


func _on_unequip_button_pressed():
	pass # replace with function body


func _on_equip_button_pressed():
	pass # replace with function body
