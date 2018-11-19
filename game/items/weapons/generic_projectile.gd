# By Jan Domalaon

# Script for projectiles (arrows, bolts).

extends Area2D

var proj_dmg
var proj_dmg_type
var proj_rot
var proj_speed
var proj_pierce
var velocity
var weapon_user
var proj_dest


func _ready():
	#self.set_position(Vector2(0, 32))
	pass


func _physics_process(delta):
	$".".show()
	self.set_position(get_position() + velocity  * delta)


func set_vars(dest, speed, user, dmg, dmg_type, is_piercing, color):
	proj_speed = speed
	velocity = speed * dest.normalized()
	proj_dest = dest
	weapon_user = user
	proj_dmg = dmg
	proj_dmg_type = dmg_type
	proj_pierce = is_piercing
	modulate = color
	if user == "player":
		look_at(get_global_mouse_position())
	else:
		look_at(get_parent().get_node("player").position)


func _on_projectile_body_entered(body):
	if (body.is_in_group("walls") or body.is_in_group("doors")):
		queue_free()
	if (weapon_user == "player"):
		if (body.is_in_group("enemies")):
			body.receive_phys_damage(proj_dmg, proj_dmg_type)
			# If the proj is not "piercing", destroy on contact
			if (not proj_pierce):
				queue_free()
	elif (weapon_user == "mob"):
		if (body.is_in_group("player")):
			body.receive_phys_damage(proj_dmg, proj_dmg_type)
			if (not proj_pierce):
				queue_free()
