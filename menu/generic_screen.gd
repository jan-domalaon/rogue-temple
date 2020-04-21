extends Control


func disable_menu_buttons(toggle):
	# Disables all buttons that are tagged as options
	for button in get_tree().get_nodes_in_group("option"):
		if toggle:
			button.set_disabled(true)
		else:
			button.set_disabled(false)
