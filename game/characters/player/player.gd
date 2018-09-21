# By Jan Domalaon

# TODO: Camera zoom


extends "res://game/characters/character.gd"


# Default values
const DEF_MOVE_SPEED = 100

onready var cursor_pos = get_global_mouse_position()

func _ready():
	set_physics_process(true)
	set_process_input(true)
	set_process(true)

func _physics_process(delta):
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
	move_and_collide(motion)
	if (is_on_wall()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move_and_collide(motion)

func _process(delta):
	# Flips the player sprite horizontally to mimic the player facing direction.
	cursor_pos = get_global_mouse_position()
	if (cursor_pos.x >= position.x):
		get_node("sprite").set_flip_h(true)
	else:
		get_node("sprite").set_flip_h(false)

func _input(event):
	# If primary_attack, do weapon's primary attack
	if (event.is_action_pressed('primary_attack')):
		pass