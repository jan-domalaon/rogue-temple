# By Jan Domalaon

# Script for bows. Will handle shooting, drawing, producing projectile
# Draw time is the primary attack speed

extends "res://game/items/weapons/weapon.gd"

# Speed of the projectile shot
export (int) onready var projectile_speed = 200
export var projectile = "res://game/items/weapons/generic_projectile.tscn"
export var piercing = false

var can_fire = false
var arrow = load(projectile)


func make_draw_bow():
	self.show()
	
	if (user_type == "player"):
		$".".look_at(get_global_mouse_position())
	else:
		# Update look direction. Look at player
		update_look_dir()
		$".".look_at(look_dir)
	$draw_timer.set_wait_time(primary_as)
	# Disable weapon_area. The bow shouldn't damage if it is being drawn
	
	# Slow user's movespeed by a bit


func make_reset_bow():
	self.hide()
	$draw_timer.stop()


func _on_draw_timer_timeout():
	# Bow is ready to be released and shoot projectile
	$AnimationPlayer.play("bow_draw")
	can_fire = true
	$draw_timer.stop()
	$draw_timer.set_wait_time(primary_as)


func fire_bow():
	# Shoot a projectile towards mouse pos
	if (can_fire):
		print("fired bow!")
		can_fire = false
		find_node("sprite").set_region_rect(Rect2(0, 0, 16, 16))
		$weapon_area/hitbox.set_disabled(true)
		$".".hide()
		
		# Instance arrow, shoot towards mouse
		var arrow_instance = arrow.instance()
		# Add arrow to the world (level)
		get_parent().get_parent().add_child(arrow_instance)
		# Arrow spawns on the characters's position
		arrow_instance.position = get_parent().get_global_position()
		# Arrow will go towards the mouse position (based on player's position, not global pos)
		if (user_type == "player"):
			arrow_instance.set_vars(get_parent().get_local_mouse_position(), projectile_speed, user_type, primary_damage, primary_dmg_type, piercing, Color(1,1,1))
		else:
			# User type is a mob. Set vars accordingly
			# Get player's position locally (ie player's pos based on enemy as origin, not level's origin)
			
			arrow_instance.set_vars((get_parent().get_parent().get_node("player").position - get_parent().position), projectile_speed, user_type, primary_damage, primary_dmg_type,
			piercing, get_parent().mob_color)

