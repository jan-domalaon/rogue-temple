extends NinePatchRect

const PRIMARY_DMG_TEXT = "Primary Damage: "
const SECONDARY_DMG_TEXT = "Secondary Damage: "


func _ready():
	self.hide()
	get_owner().get_parent().get_parent().connect("inventory_item_select", self, "on_inventory_item_select")


func on_inventory_item_select(item_name, primary_dmg, primary_dmg_type, secondary_dmg, secondary_dmg_type, tex):
	self.show()
	$CenterContainer/description_container/CenterContainer/item_text/item_name.set_text(item_name)
	if (primary_dmg == null):
		$CenterContainer/description_container/CenterContainer/item_text/attributes_container.hide()
	else:
		$CenterContainer/description_container/CenterContainer/item_text/attributes_container.show()
		$CenterContainer/description_container/CenterContainer/item_text/attributes_container/primary_dmg.set_text(PRIMARY_DMG_TEXT +
		str(primary_dmg) + " " + str(primary_dmg_type))
		$CenterContainer/description_container/CenterContainer/item_text/attributes_container/secondary_dmg.set_text(SECONDARY_DMG_TEXT +
		str(secondary_dmg) + " " + str(secondary_dmg_type))
	$CenterContainer/description_container/NinePatchRect/MarginContainer/item_sprite.set_texture(tex)