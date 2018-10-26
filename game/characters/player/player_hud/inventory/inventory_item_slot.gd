extends TextureButton

signal item_selected

export (String) var slot_name = ""


func _ready():
	# Watch for updates on item slot texture
	get_owner().get_parent().get_parent().connect("update_slot_tex", self, "on_update_slot_tex")


func _on_inventory_item_slot_pressed():
	# Want to signal "item_selected"
	# Displays on item description box
	pass # replace with function body



func on_update_slot_tex(tex, equipment_key):
	if (equipment_key.to_lower() == slot_name):
		# Use only the first sprite of the texture
		var tex_subregion = AtlasTexture.new()
		tex_subregion.set_atlas(tex)
		tex_subregion.set_region(Rect2(0, 0, 16, 16))
		$TextureRect.set_texture(tex_subregion)
		print("updated " + str(slot_name) + " slot texture!")