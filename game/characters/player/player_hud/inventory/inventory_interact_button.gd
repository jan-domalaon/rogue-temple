extends Button

signal interact_inventory

export (String) var function = "Use"


func _on_interact_inventory_pressed():
	emit_signal("interact_inventory")
