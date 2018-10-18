extends Label

func _process(delta):
	set_text("Armor: " + str(get_parent().get_parent().get_parent().get_node("shield").get("shield_hp")))