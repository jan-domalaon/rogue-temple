# By Jan Domalaon

# Door script. Handles opening doors

extends Node2D

var closed = true
var interact_door = false

func _physics_process(delta):
	for body in $interact_area.get_overlapping_bodies():
		if ("player" in body.get_groups() and closed and Input.is_action_pressed("interact")):
			print("open sesame")
			# Disables collisions and changes sprite texture (might add an animation later on)
			# Change collision layer mask to doors instead of walls. Workaround for raycast
			# going through disabled shapes
			$closed_door/door_body/door_collision.set_disabled(true)
			$closed_door/door_body.set_collision_layer_bit(4, 1)
			$closed_door/door_body.set_collision_layer_bit(2, 0)
			$interact_area/interact_shape.set_disabled(true)
			$interact_area.set_collision_layer_bit(4, 1)
			$interact_area.set_collision_layer_bit(2, 0)
			# Turn on navigation through this door
			$AnimationPlayer.play("open_door")
			closed = false