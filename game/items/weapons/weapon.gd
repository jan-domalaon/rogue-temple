extends Node2D

onready var weapon_tween = $weapon_area/weapon_tween

export var weapon_name = "Weapon (Parent Weapon)"
export var primary_damage = 1
export var secondary_damage = 1
export var primary_dmg_type = 'c'
export var secondary_dmg_type = 'p'
export var user_type = "player"
export var primary_as = 0.75
export var secondary_as = 0.5

onready var cursor_pos = get_viewport().get_mouse_position() 

func _ready():
	set_process_input(true)

func _input(event):
	if (Input.is_action_pressed("primary_attack")):
		make_swing()
	if (Input.is_action_pressed("secondary_attack")):
		# Do a downward swing
		pass

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
	weapon_tween.start()

func make_downward_swing():
	pass

func make_thrust():
	pass


