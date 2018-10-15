# By Jan Domalaon

# TODO: Camera zoom


extends "res://game/characters/character.gd"


# Default values
const DEF_MOVE_SPEED = 100

onready var cursor_pos = get_global_mouse_position()

signal player_moved

# Inventory
var inventory_size = 2
var inventory_space = []


func _ready():
	set_physics_process(true)
	set_process_input(true)
	set_process(true)

func _physics_process(delta):
	# Movement
	movement_dir.x = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	movement_dir.y = -int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
	movement()
	# Knockback between enemies with knockback and player
	# Player is knockbackable.
	knockback()
	
	# Emit signal to update player position. Meant for mob pathfinding when aggressive
	if (movement_dir != Vector2(0,0)):
		emit_signal("player_moved", get_global_position())

func _process(delta):
	# Flips the player sprite horizontally to mimic the player facing direction.
	cursor_pos = get_global_mouse_position()
	
	if (cursor_pos.x >= position.x):
		get_node("sprite").set_flip_h(true)
	else:
		get_node("sprite").set_flip_h(false)
	
	# If flickering, the player can't use their weapon
	$weapon.set_process_input(false) if flickering else $weapon.set_process_input(true)

func _input(event):
	# If primary_attack, do weapon's primary attack
	if (event.is_action_pressed('primary_attack')):
		pass
	
	if (event.is_action_pressed('interact')):
		var interactables = $knockback_area.get_overlapping_areas()
		if (interactables.size() > 0):
			var interacted = false
			var w = false
			if ((interactables[0].is_in_group('items')) and (inventory_space.size() < inventory_size)):
				inventory_space.append(interactables[0].name)
				# Sort inventory alphabetically
				#inventory_space.sort()
				print(inventory_space)
				interactables[0].queue_free()
				interacted = true
			elif ((interactables[0].is_in_group("level_change"))):
				pass