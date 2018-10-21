# By Jan Domalaon

# Script for bows. Will handle shooting, drawing, producing projectile
# Draw time is the primary attack speed

extends "res://game/items/weapons/weapon.gd"

# Speed of the projectile shot
export (int) var projectile_speed = 80

var can_fire = false


func make_draw_bow():
	self.show()
	$".".look_at(get_global_mouse_position())
	$draw_timer.set_wait_time(primary_as)
	# Disable weapon_area. The bow shouldn't damage if it is being drawn


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
		$weapon_area/sprite.set_region_rect(Rect2(0, 0, 16, 16))
		$weapon_area/hitbox.set_disabled(true)
		$".".hide()
