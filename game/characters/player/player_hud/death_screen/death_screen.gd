# By Jan Domalaon
# Death screen script. Handles random death messages and death screen buttons


extends Control


const DEATH_MESSAGES = ["You died.", "It is what it is.", "RIP in Pepperoni", "HAH GOTTEEM", "It do be like that sometimes.", "Congratulations! You died."]


func _ready():
	# Connect to player signal when they're dead
	get_parent().get_parent().connect("player_died", self, "on_player_death")
	
	# Only show "Load Save" button if save exists
	if not(save.save_file_exists()):
		$VBoxContainer/CenterContainer/VBoxContainer/load_button.hide()


func on_player_death():
	# Get a random death message and display to death message node
	var death_text = DEATH_MESSAGES[randi()%DEATH_MESSAGES.size()+1]
	$VBoxContainer/message_container/death_message.set_text(death_text)


func _on_load_button_pressed():
	# Load previous save
	save.load_game()


func _on_return_button_pressed():
	# Switch scene to main menu
	get_tree().change_scene("res://menu/main_menu/menu.tscn")
