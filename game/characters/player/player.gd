# By Jan Domalaon

extends KinematicBody2D

export (int) var move_speed = 200

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	set_process(true)

func _fixed_process(delta):
	# Movement
	var motion = Vector2()
	if (Input.is_action_pressed("move_up")):
		motion += Vector2(0, -1)
	if (Input.is_action_pressed("move_down")):
		motion += Vector2(0, 1)
	if (Input.is_action_pressed("move_left")):
		motion += Vector2(-1, 0)
	if (Input.is_action_pressed("move_right")):
		motion += Vector2(1, 0)
	motion = motion.normalized()* move_speed * delta
	move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)

func _process(delta):
	# Flips the player sprite horizontally to mimic the player facing direction.
	cursor_pos = get_node("player_camera").get_global_mouse_pos()
	if (cursor_pos.x >= get_pos().x):
		get_node("sprite").set_flip_h(true)
	else:
		get_node("sprite").set_flip_h(false)

func _input(event):
	pass