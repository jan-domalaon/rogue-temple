# By Jan Domalaon
# Generic proximity trap. Triggered when a character walks on the trigger area.
# Spikes, poison flower, kiss of the abyss, barrel of snakes, overgrowth, etc.


extends Area2D

export (String) var trap_name = "Generic Proximity Trap"
# All traps start off as not triggered
onready var triggered = false


func _on_trap_body_entered(body):
	# Every trap will have their own individual function when triggered
	pass # replace with function body
