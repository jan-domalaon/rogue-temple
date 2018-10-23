# By Jan Domalaon

# Door script. Handles opening doors

extends Node2D

var closed = true
var interact_door = false


func open_door():
	if (closed):
		print("open sesame")
		# Disables collisions and changes sprite texture (might add an animation later on)
		# Change collision layer mask to doors instead of walls. Workaround for raycast
		# going through disabled shapes
		$door_collision.set_disabled(true)
		$".".set_collision_layer_bit(4, 1)
		$".".set_collision_layer_bit(2, 0)
		$interact_area/interact_shape.set_disabled(true)
		$interact_area.set_collision_layer_bit(4, 1)
		$interact_area.set_collision_layer_bit(2, 0)
		# Turn on navigation through this door
		$AnimationPlayer.play("open_door")
		closed = false