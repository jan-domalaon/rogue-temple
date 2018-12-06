# New humanoid script. Based on new_generic_mob


extends "res://game/characters/mobs/generic_mob/new_generic_mob.gd"


export var melee_weapon_path = ""
export var ranged_weapon_path = ""


func _ready():
	# Set attack timer time and connectiom
	$attack_timer.set_wait_time($weapon.get("secondary_as"))
	$attack_timer.connect("timeout", self, "on_attack_timer_timeout")


func state_melee_attack():
	# Keep the weapon hitbox disabled if the mob is not attacking
	# FOR USE WITH DOWNWARD SWING
	$weapon/weapon_area/hitbox.set_disabled(true)
	# Mob can attack when cooldown is finished and player is still alive
	if (can_attack and player_health > 0 and not flickering):
		can_attack = false
		$attack_timer.start()
		$weapon.make_downward_swing()
		current_state = "CHASE"


func state_ranged_attack():
	# Each ranged weapon has a different shoot function
	if ($weapon.weapon_type == "BOW"):
		# Fire bow when can_fire is true
		if ($weapon.can_fire):
			movement_dir = Vector2(0,0)
			$weapon.fire_bow()
		else:
			# Draw bow if bow can't fire
			$weapon.make_draw_bow()
			if ($weapon/draw_timer.is_stopped()):
				$weapon/draw_timer.start()
		
		# Switch to CHASING state if humanoid can't see player
		if (not detect_ray(get_global_position(), get_parent().get_node("player").get_global_position())):
			# Reset bow
			$weapon.make_reset_bow()
			current_state = "CHASE"


func on_attack_timer_timeout():
	can_attack = true