extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var paused = false

func _ready():
	set_process_input(true)
	self.hide()

func _input(event):
	if (event.is_action_pressed('pause')):
		if paused == true:
			# Set pause to false
			resume_game()
		else:
			# Set pause to true
			# Show pause menu and pause game
			paused = true
			get_tree().set_pause(true)
			self.show()

func _on_resume_pressed():
	# Resume game
	resume_game()

func resume_game():
	# Paused to false, hide pause menu
	paused = false
	get_tree().set_pause(false)
	self.hide()

func _on_quit_pressed():
	# Save game
	# Return to menu scene. Unpause game.
	get_tree().set_pause(false)
	get_tree().change_scene("res://scenes/menu/menu.tscn")

func _on_save_pressed():
	pass # replace with function body

func _on_options_pressed():
	# Make options container visible and hide other elements.
	get_node("pause_menu_container").hide()
	get_node("options_container").show()

