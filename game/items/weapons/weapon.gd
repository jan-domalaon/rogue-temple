extends Node2D

onready var weapon_tween = $weapon_area/weapon_tween

export var weapon_name = "Test Mace"
export var primary_damage = 1
export var secondary_damage = 1
export var primary_dmg_type = 'c'
export var secondary_dmg_type = 'p'
export var user_type = "player"
export var primary_as = 0.75
export var secondary_as = 0.5

onready var cursor_pos = get_viewport().get_mouse_position() 

func _ready():
	if (user_type == "player" or ("player" in get_parent().get_groups())):
		set_process_input(true)
	else:
		set_process_input(false)

func _input(event):
	if (Input.is_action_pressed("primary_attack")):
		reset_weapon()
		make_swing()
	if (Input.is_action_pressed("secondary_attack")):
		# Do a downward swing
		reset_weapon()
		make_downward_swing()

func _process(delta):
	pass

func _on_weapon_area_body_entered(body):
	pass # replace with function body

func make_swing():
	# Reset position of weapon and rotating Node2D
	get_node(".").set_rotation(0)
	get_node("weapon_area").set_position(Vector2(32, 0))
	
	# Swing the weapon_area with the Node2D as the pivots
	weapon_tween.interpolate_method(get_node("."), 
	"set_rotation", get_angle_to(get_global_mouse_position()) - (PI / 2), 
	get_angle_to(get_global_mouse_position()) + (PI / 2), primary_as, 
	weapon_tween.TRANS_EXPO, weapon_tween.EASE_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_modulate", Color(1, 1, 1, 1), Color(1,1,1,0), primary_as, 
	weapon_tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_scale", Vector2(1, 1), Vector2(0.5, 1), primary_as,
	weapon_tween.TRANS_CUBIC, weapon_tween.EASE_OUT)
	weapon_tween.start()

func make_downward_swing():
	$weapon_area.set_position(Vector2(32, 0))
	$".".look_at(get_global_mouse_position())
	
	# Weapon stays in same position, starts faded out, then in, then out
	# Don't forget to add timer to hitbox when fading in
	weapon_tween.interpolate_method($weapon_area, "set_modulate", Color(1, 1, 1, 1), Color(1,1,1,0), secondary_as, 
	weapon_tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	weapon_tween.interpolate_method($weapon_area, "set_scale", Vector2(1, 1), Vector2(0.75, 1), secondary_as,
	weapon_tween.TRANS_CUBIC, weapon_tween.EASE_OUT)
	weapon_tween.start()

func make_thrust():
	$weapon_area.set_position(Vector2(0, 0))
	$".".look_at(get_global_mouse_position())
	
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