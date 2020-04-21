# Game over screen

extends Control


func _ready():
	# Connect to level's signal for game over
	get_tree().get_root().get_node("level").connect("game_over", self, "on_game_over")


func _on_quit_pressed():
	get_tree().quit()


func _on_return_pressed():
	# Return to main menu.
	get_tree().paused = false
	get_tree().change_scene("res://menu/main_menu/menu.tscn")


func on_game_over():
	$animation_player.play("fade_in")
	yield($animation_player, "animation_finished")
	get_tree().paused = true
