# By Jan Domalaon

# Door script. Handles opening doors

extends Node2D

var closed = true
var interact_door = false
onready var player = get_parent().get_node("player")

func _physics_process(delta):
	for body in $interact_area.get_overlapping_bodies():
		if ("player" in body.get_groups() and closed and Input.is_action_pressed("interact")):
			print("open sesame")
			# Disables collisions and changes sprite texture (might add an animation later on)
			$closed_door/door_body/door_collision.set_disabled(true)
			$AnimationPlayer.play("open_door")
			closed = false