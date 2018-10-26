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
		$TextureRect.set_texture(tex)
		print("updated " + str(slot_name) + " slot texture!")