extends CanvasLayer


func change_scene_transition(path, button_container=null, delay=0.5):
	# Disable buttons if this is a menu
	if button_container != null:
		UIFunctions.disable_ui_buttons(button_container)
	handle_scene_transition(path, delay)


func handle_scene_transition(path, delay=0.5):
	yield(get_tree().create_timer(delay), "timeout")
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	$AnimationPlayer.play_backwards("fade")
	yield($AnimationPlayer, "animation_finished")
