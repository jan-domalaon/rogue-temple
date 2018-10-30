# By Jan Domalaon

# Player script. Mostly controls input.


extends "res://game/characters/character.gd"


# Default values
const DEF_MOVE_SPEED = 100

onready var cursor_pos = get_global_mouse_position()
onready var old_hp = health

signal player_moved
signal max_health_changed(max_health)
signal update_player_stats(hp, max_hp, armor, max_ms, xp, next_lvl_xp, lvl)

# Inventory
var inventory_size = 2
var inventory_space = []
var current_weapon = "primary"
# Stats
var player_xp = 0
var player_level = 1
var player_armor = 0
# Will change as the player levels
var next_lvl_xp = 100


func _ready():
	set_physics_process(true)
	set_process_input(true)
	set_process(true)
	emit_signal("max_health_changed", health)
	emit_signal("health_changed", health)
	
	# Get equipment from inventory
	get_weaponry()
	get_shield()
	
	# Set appropriate stats from inventory
	player_armor = $inventory.get_armor_value()


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
		find_node("sprite").set_flip_h(true)
	else:
		find_node("sprite").set_flip_h(false)
	
	emit_signal("update_player_stats", health, max_health, player_armor, max_move_speed, player_xp, next_lvl_xp, player_level)


func _input(event):
	# These actions can only be done if the player is not flickering
	if (not flickering):
		
		if (shield_ready and event.is_action_pressed('block')):
			use_shield(true)
		
		if (shield_ready and event.is_action_released("block")):
			use_shield(false)
		
		if ($weapon.get("can_attack") and not shield_up):
			# Special conditions for ranged weapons
			if ($weapon.is_in_group("ranged_weapons")):
				# Bow conditions
				if ($weapon.get("weapon_type") == "BOW"):
					if Input.is_action_pressed("primary_attack"):
						# Only shoot a bow when releasing
						$weapon.make_draw_bow()
					if Input.is_action_just_pressed("primary_attack"):
						$weapon/draw_timer.start()
					if Input.is_action_just_released("primary_attack"):
						$weapon.make_reset_bow()
					if Input.is_action_just_released("primary_attack") and $weapon.get("can_fire"):
						$weapon.fire_bow()
			else:
				# Melee weapon attacks
				if (event.is_action_pressed('primary_attack')):
					$weapon.make_primary_attack()
				
				if(event.is_action_pressed("secondary_attack")):
					$weapon.make_secondary_attack()
		
	if (event.is_action_pressed('interact')):
		var interactables = $knockback_area.get_overlapping_areas()
		if (interactables.size() > 0):
			var interacted = false
			var w = false
			# If the interactable is an item and is in item container
			if ((interactables[0].is_in_group('items')) and interactables[0].get_parent().get_name() == "item_container"):
				print("picked up " + str(interactables[0].get_name()))
				$inventory.pickup_item(interactables[0])
				interacted = true
			# If the interactable is a level change
			elif ((interactables[0].is_in_group("level_change"))):
				pass
			# If the interactable is a door
			elif (interactables[0].get_parent().is_in_group("doors")):
				interactables[0].get_parent().open_door()
	
	if (event.is_action_pressed("weapon_swap")):
		player_swap_weapon()


func player_swap_weapon():
	# Secondary is primary weapon, or vice versa
	# Swap weapons in inventory
	$inventory.swap_weapon()
	# Rename weapons
	$sheathed_weapon.name = "intermediate"
	$weapon.name = "sheathed_weapon"
	$intermediate.name = "weapon"
	print("primary weapon: " + $weapon.weapon_name)


func get_weaponry():
	# Get name from inventory and get resource path from item database
	var primary_weapon_path = item_db.WEAPON[$inventory.equipment["Primary"][0]]
	var secondary_weapon_path = item_db.WEAPON[$inventory.equipment["Secondary"][0]]
	var primary = load(primary_weapon_path)
	var secondary = load(secondary_weapon_path)
	
	# Instance weapons
	var primary_instance = primary.instance()
	var secondary_instance = secondary.instance()
	
	# Rename and set values accordingly
	primary_instance.name = "weapon"
	secondary_instance.name = "sheathed_weapon"
	primary_instance.user_type = "player"
	secondary_instance.user_type = "player"
	primary_instance.set_scale(Vector2(0.5, 0.5))
	secondary_instance.set_scale(Vector2(0.5, 0.5))
	primary_instance.hide()
	secondary_instance.hide()
	
	# Add weaponry to player. Deferred b/c this is called in _ready()
	call_deferred("add_child", primary_instance)
	call_deferred("add_child", secondary_instance)


func get_shield():
	# Same format as get_weaponry(), but for shields
	var shield_path = item_db.SHIELD[$inventory.equipment["Shield"][0]]
	var shield = load(shield_path)
	var shield_instance = shield.instance()
	
	shield_instance.name = "shield"
	shield_instance.hide()
	
	call_deferred("add_child", shield_instance)
	call_deferred("connect_shield")
