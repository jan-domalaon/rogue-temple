extends TextureProgress


func update_bar_label():
	# Update minimum and maximum values
	$CenterContainer/bar_label.set_text(str(get_value()) + " / " + str(get_max()))


func _on_hud_update_max_health_bar(max_health):
	$".".set_max(max_health)
	update_bar_label()


func _on_hud_update_health_bar(health):
	$".".set_value(health)
	update_bar_label()
