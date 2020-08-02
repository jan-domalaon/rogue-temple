extends Node

func disable_ui_buttons(container):
	var container_elements = container.get_children()
	for element in container_elements:
		if element is Button:
			element.set_disabled(true)
#		else:
#			disable_ui_buttons(element)
