# By Jan Domalaon (MaritimesGameworks)

extends KinematicBody2D


# TODO: Level changing and player_vars transferring

# Placeholder variables
const DEFAULT_MOVE_SPEED = 100
const DEFAULT_SWORD_PATH = "res://game/characters/player/STUFF TO PORT AND REORGANIZE/sword_thrust.tscn"
# Default weapon for testing
#onready var sword_tween = get_node("rotating/sword/Tween")
#onready var sword = get_node("rotating/sword")

# Player move speed. Walking is half of this.
export var move_speed = 100
# Used when the move speed changes from attacking.
var old_ms = move_speed
# Attack speeds
export var primary_as = 0.75
export var secondary_as = 0.1
export var weapon_type = 'blade'
export var health = 20
export var armor = 0
export var primary_dmg = 2
export var secondary_dmg = 2
var walk = false
var can_attack = true
# RPG Stats
var strength = 10
var experience = 0

onready var weapon_timer = get_node("weapon_timer")
onready var cursor_pos = get_viewport().get_mouse_position() 
var old_shape = null
# Equipped weapon is the path of a weapon, not the string.
var equipped_weapon = null
var weapon_tween = null
# Changes depending on type of attack. Meant for damage given to enemy.
var player_dmg = 0
var global_player_vars 	= null
var inventory 			= null
var weapon_db 			= null
onready var weapon 		= null
# Level name
var level_name 			= null

signal level_change


#func _enter_tree():
#	global_player_vars 		= get_node("/root/player_variables")
#	inventory 				= global_player_vars.inventory
#	weapon_db				= get_node("/root/weapons_db")
#	# Set variables from a previous scene.
#	primary_dmg = global_player_vars.primary_dmg
#	secondary_dmg = global_player_vars.secondary_dmg
#	health = global_player_vars.health
#	armor = global_player_vars.armor
#	print(armor)
#	# Load PackedScene from player_vars. Instancing occurs in _ready()
#	equipped_weapon = load(weapon_db.WEAPONS[global_player_vars.equipped_weapon])
#	# Set level
#	level_name = get_parent().level_name

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_physics_process(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	set_process_input(true)
	set_process(true)
	
	# Instance equipped weapon from global player vars/last scene.
	# weapon = equipped_weapon.instance()
	weapon = load('res://game/characters/player/STUFF TO PORT AND REORGANIZE/sword_thrust.tscn').instance()
	get_node("rotating").add_child(weapon)
	get_node("rotating/weapon").free()
	weapon.set_name('weapon')
	weapon.hide()
	
	# Set appropriate vars in this scene from instanced equipped weapon
	weapon_tween = weapon.get_node('Tween')
	primary_dmg = weapon.primary_dmg
	secondary_dmg = weapon.secondary_dmg
	primary_as = weapon.primary_as
	secondary_as = weapon.secondary_as
	# Add weapon signal to rotating node.
	weapon.connect("body_enter", get_node('rotating'), "_on_weapon_body_enter")
	# Create weapon timer and disable weapon collision.
	weapon_timer.set_one_shot(true)
	weapon_timer.connect("timeout", self, "on_attack_timeout")
	disable_collision(weapon)
	
	# Signal connection for level change
	self.connect('level_change', get_parent().get_node('YSort/next_level_change/'), '_on_level_change')
	# Defunct for now due to design changes (ie no previous level changes)
#	self.connect('level_change', get_parent().get_node('prev_level_change'), '_on_level_change')

func _physics_process(delta):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	# Movement events. 
	# REMEMBER THAT THE COORDS IS THE BOTTOM HALF OF CARTESIAN GRID
	var motion = Vector2()
	if (Input.is_action_pressed("move_up")):
		motion += Vector2(0, -1)
	if (Input.is_action_pressed("move_down")):
		motion += Vector2(0, 1)
	if (Input.is_action_pressed("move_left")):
		motion += Vector2(-1, 0)
	if (Input.is_action_pressed("move_right")):
		motion += Vector2(1, 0)
	# Normalize vector, then times speed and frame delta
	motion = motion.normalized()* move_speed * delta
	# Move with the given vector
	move_and_collide(motion)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	# Removes friction created by running towards a wall/hitbox and moving at an opposite direction.
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move_and_collide(motion)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review

func _input(event):
	# Toggles walking. Walk is half of the move_speed.
	# What happens if there is an effect on the player that affects move_speed?
	if (event.is_action_pressed("walk")):
		if (walk == true):
			move_speed = DEFAULT_MOVE_SPEED
			walk = false
		else:
			move_speed = move_speed / 2
			walk = true
	# Primary attack (for sword, swing)
	if (Input.is_action_pressed("primary_attack") && can_attack == true):
		old_ms = move_speed
		# Slow player down when moving. In future updates, tie move_speed to weapon weight.
		move_speed = move_speed * 0.6
		if (weapon_type == 'blade'):
			player_dmg = [primary_dmg, 'c']
			enable_collision(weapon)
			get_node("rotating").look_at(cursor_pos)
			can_attack = false
			weapon_timer.set_wait_time(primary_as)
			weapon.show()
			make_swing()
			weapon_timer.start()
	# Secondary attack (for sword, thrust)
	if (Input.is_action_pressed("secondary_attack") && can_attack == true):
		old_ms = move_speed
		move_speed = move_speed * 0.6
		if (weapon_type == 'blade'):
			player_dmg = [secondary_dmg, 'p']
			enable_collision(weapon)
			get_node("rotating").look_at(cursor_pos)
			# Meant to prevent spamming.
			can_attack = false
			# thrust_speed * 2 meant to include the thrust returning to player
			weapon_timer.set_wait_time(secondary_as * 2)
			weapon.show()
			make_thrust()
			weapon_timer.start()
	# Interact (with an item, door, switch)
	if (Input.is_action_pressed('interact')):
		# Check nodes in interact area
		var interactable_nodes = get_node("interact_area").get_overlapping_areas()
		if interactable_nodes.size() > 0:
			# If theres an item, pick up. Pick up only one item!
			var interacted = false
			var i = 0
			while (not interacted or i > interactable_nodes.size()):
				# Pick up item
				if interactable_nodes[i].is_in_group('items'):
					inventory.append(interactable_nodes[i].item_name)
					# Sort inventory alphabetically
					inventory.sort()
					print(inventory)
					interactable_nodes[i].queue_free()
					interacted = true
				elif interactable_nodes[i].is_in_group('level_change'):
					# Send the appropriate stats from this scene to player_vars
					update_player_vars()
					emit_signal('level_change')
					interacted = true
				i += 1

func _process(delta):
	# Turns the player to the direction of the cursor.
	# If cursor.x >= player.x, flip sprite
	# Else, undo flip
	cursor_pos = get_node("player_camera").get_global_mouse_position()  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	# BUG: Sprite not flipping. Should be that flip occurs when cursor >= 0 to PLAYER, not position.
	if (cursor_pos.x >= get_position().x):  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		get_node("player_sprite").set_flip_h(true)
	else:
		get_node("player_sprite").set_flip_h(false)

func disable_collision(weapon):
	# Stores the original shape. Removes all shapes afterwards.
    old_shape = weapon.get_node("CollisionShape2D").get_shape()
    weapon.clear_shapes()

func enable_collision(weapon):
	# Adds the former shape to the weapon.
    weapon.add_shape(old_shape)

func make_thrust():
	# Secondary attack for blades. Primary attack for polearms.
	# Tweening
	weapon_tween.interpolate_method(weapon, "set_pos", Vector2(0,0), Vector2(0, 32), secondary_as, weapon_tween.TRANS_BACK, weapon_tween.EASE_OUT)
	weapon_tween.interpolate_property(weapon, "transform/pos", Vector2(0, 32), Vector2(0,0), secondary_as, weapon_tween.TRANS_BACK, weapon_tween.EASE_OUT, secondary_as)
	weapon_tween.start()

func make_swing():
	# Primary attacks for blades, blunt weaponry. Secondary attack for polearms.
	# Put blade further from player.
	weapon.set_position(Vector2(0, 32))  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	# Tweening: needs starting angle. Look_at() in input ensures that the sword will be facing perpendicular at swing apex.
	weapon_tween.interpolate_method(get_node("rotating"), "set_rotation", get_angle_to(cursor_pos) - (PI / 2), get_angle_to(cursor_pos) + (PI / 2), primary_as, weapon_tween.TRANS_EXPO, weapon_tween.EASE_OUT)
	weapon_tween.start()

func on_attack_timeout():
	# Hide blade, can attack again, revert move_speed, disable collision.
	if (weapon_type == 'blade'):
		weapon.hide()
	can_attack = true
	move_speed = old_ms
	disable_collision(weapon)

func update_player_vars():
	# Updates the player vars when changing levels.
	global_player_vars.health = health

