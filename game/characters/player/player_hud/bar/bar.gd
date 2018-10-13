extends HBoxContainer

export(int) var minimum = 0 setget set_minimum_value
export(int) var maximum = 20 setget set_maximum_value
export(int) var current = 20 setget set_current_value

func set_minimum_value(value):
	minimum = value
	$progress.set_min(value)
	update_bar_label()

func set_maximum_value(value):
	maximum = value
	$progress.set_max(value)
	update_bar_label()

func set_current_value(value):
	current = value
	$progress.set_value(value)
	update_bar_label()

func update_bar_label():
	# Update minimum and maximum values
	$progress/bar_label.set_text(str(current), " / ", str(maximum))