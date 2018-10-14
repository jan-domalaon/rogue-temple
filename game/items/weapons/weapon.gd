# By Jan Domalaon
#
# Weapon script responsible for animation and damage stats

extends Node2D


onready var weapon_tween = $weapon_area/weapon_tween
# For tilemap collision
onready var walls = get_parent().get_parent().get_node("nav/tilemap")
onready var doors = get_parent().get_parent().get_node("doors")

export var weapon_name = "Test Mace"
export var primary_damage = 1
export var secondary_damage = 1
export var primary_dmg_type = 'c'
export var secondary_dmg_type = 'b'
export var user_type = "player"
export var primary_as = 0.75
export var secondary_as = 0.5
export var weapon_type = "mace"

# Hitbox shape used for disable/enable collision
var old_shape = null
var attack_type = "primary"
var can_attack = true
# For getting direction of weapon depending if mob or player
var look_dir


func _ready():
	$weapon_area/hitbox.set_disabled(true)
	if (user_type == "player" or ("player" in get_parent().get_groups())):
		set_process_input(true)
	else:
		set_process_input(false)


func _input(event):
	if (Input.is_action_just_pressed("primary_attack") and can_attack):
		$weapon_cooldown.set_wait_time(primary_as)
		attack_type = "primary"
		$weapon_cooldown.start()
		if (weapon_type in ["mace", "sword", "spear", "staff"]):
			make_swing()
	elif (Input.is_action_just_pressed("secondary_attack") and can_attack):
		$weapon_cooldown.set_wait_time(secondary_as)
		attack_type = "secondary"
		$weapon_cooldown.start()
		if (weapon_type in ["mace", "staff"]):
			make_downward_swing()
		elif (weapon_type in ["sword", "spear"]):
			make_thrust()


func _on_weapon_area_body_entered(body):
	var map_collision = false
	var enemy_group
#	print(get_parent().get_name(), " ", $weapon_area.get_overlapping_bodies())
#	for body in $weapon_area.get_overlapping_bodies():
#		if "doors" in body.get_groups() or "walls" in body.get_groups():
#			map_collision = true
	
	# Verify the owner of this weapon. Get correct enemy group
	if ("player" in get_parent().get_groups()):
		enemy_group = "enemies"
	elif ("enemies" in get_parent().get_groups()):
		enemy_group = "player"
	# Deliver damage to the user's enemy group
	# Do not deliver damage if the weapon touches a wall
	if (not map_collision):
		if (enemy_group in body.get_groups() and (body.get("flickering") == false)):
			if (attack_type == "primary"):
				body.receive_phys_damage(primary_damage, primary_dmg_type)
			elif (attack_type == "secondary"):
				body.receive_phys_damage(secondary_damage, secondary_dmg_type)


func make_swing():
	reset_weapon()
	# Reset position of weapon and rotating Node2D
	get_node(".").set_rotation(0)
	get_node("weapon_area").set_position(Vector2(32, 0))
	
	# Update look_dir to get correct rotation
	update_look_dir()
	
	# Swing the weapon_area with the Node2D as the pivots
	weapon_tween.interpolate_method(get_node("."), 
	"set_rotation", get_angle_to(look_dir) - (PI / 2), 
	get_angle_to(look_dir) + (PI / 2), primary_as, 
	weapon_tween.TRANS_EXPO, weapon_tween.EASE_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_modulate", Color(1, 1, 1, 1), Color(1,1,1,0), primary_as, 
	weapon_tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_scale", Vector2(1, 1), Vector2(0.5, 1), primary_as,
	weapon_tween.TRANS_CUBIC, weapon_tween.EASE_OUT)
	weapon_tween.start()


func make_downward_swing():
	reset_weapon()
	# Update look_dir to get correct rotation
	update_look_dir()
	
	$weapon_area.set_position(Vector2(32, 0))
	$".".look_at(look_dir)
	
	# Weapon stays in same position, starts faded out, then in, then out
	# Don't forget to add timer to hitbox when fading in
	weapon_tween.interpolate_method($weapon_area, "set_modulate", Color(1, 1, 1, 1), Color(1,1,1,0), secondary_as, 
	weapon_tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_scale", Vector2(1.1, 1.1), Vector2(1, 1), secondary_as / 4,
	weapon_tween.TRANS_CUBIC, weapon_tween.EASE_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_scale", Vector2(1, 1), Vector2(0.75, 1), secondary_as,
	weapon_tween.TRANS_CUBIC, weapon_tween.EASE_OUT, secondary_as / 2)
	weapon_tween.start()


func make_thrust():
	reset_weapon()
	# Update look_dir to get correct rotation
	update_look_dir()
	
	$weapon_area.set_position(Vector2(0, 0))
	$".".look_at(look_dir)
	
	# Weapon starts on character. Thrusts forward, then retract back
	weapon_tween.interpolate_method($weapon_area, "set_position", Vector2(0,0), Vector2(32, 0), secondary_as / 2, weapon_tween.TRANS_BACK, weapon_tween.EASE_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_position", Vector2(32,0), Vector2(0, 0), secondary_as / 2, weapon_tween.TRANS_BACK, weapon_tween.EASE_OUT, secondary_as / 2)
	# Scale the weapon a bit for some juice
	weapon_tween.interpolate_method($weapon_area, "set_scale", Vector2(1,1), Vector2(1.25, 1.25), secondary_as / 4, weapon_tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_scale", Vector2(1.25,1.25), Vector2(1, 1), secondary_as / 4, weapon_tween.TRANS_CUBIC, Tween.EASE_IN_OUT, secondary_as / 4)
	# Fade out when retracting
	weapon_tween.interpolate_method($weapon_area, "set_modulate", Color(1, 1, 1, 1), Color(1,1,1,0), secondary_as, weapon_tween.TRANS_CUBIC, Tween.EASE_OUT, secondary_as / 2)
	weapon_tween.start()


func reset_weapon():
	# Reset the scale, position, and other transformed properties from tweening
	$weapon_area.set_scale(Vector2(1,1))
	$weapon_area.set_modulate(Color(1,1,1,1))
	$weapon_area.set_position(Vector2(0, 0))
	$".".show()
	$weapon_area/hitbox.set_disabled(false)
	can_attack = false


func _on_weapon_cooldown_timeout():
	$weapon_area/hitbox.set_disabled(true)
	$".".hide()
	can_attack = true


func update_look_dir():
	if ("player" in get_parent().get_groups()):
		look_dir = get_global_mouse_position()
	else:
		# The wielder of this weapon is a mob/humanoid
		# Mob vector to player
		look_dir = get_parent().get("player_pos")