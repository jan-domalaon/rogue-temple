extends Node


var move_speed = 0
var velocity = Vector2()


func enter():
	# Play a future idle animation
	# owner.get_node("AnimationPlayer").play("idle")
	pass


func update(delta):
	var movement_dir
	if movement_dir:
		emit_signal("finished", "MOVING")
