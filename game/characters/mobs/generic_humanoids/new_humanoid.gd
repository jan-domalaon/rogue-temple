# New humanoid script. Based on new_generic_mob


extends "res://game/characters/mobs/generic_mob/new_generic_mob.gd"


export var melee_weapon_path = ""
export var ranged_weapon_path = ""
export var unique_weapon = false


func _ready():
	$attack_timer.connect("timeout", self, "on_attack_timer_timeout")
	
	# Instance weapon and add to humanoid iff mob does not have a unique weapon
	if unique_weapon == false:
		if (is_in_group("melee_mobs")):
			var melee_weapon_instance = load(melee_weapon_path).instance()
			melee_weapon_instance.set_name("weapon")
			self.add_child(melee_weapon_instance)
			
			# Get weapon range for ability to attack
			weapon_length = get_node("weapon/weapon_area/hitbox").shape.extents.x
		elif (is_in_group("ranged_mobs")):
			var ranged_weapon_instance = load(ranged_weapon_path).instance()
			ranged_weapon_instance.set_name("weapon")
			self.add_child(ranged_weapon_instance)
		# Weapon prep. Set scale and hide weapon. Set weapon user as mob
		$weapon.set_scale(Vector2(0.5, 0.5))
		$weapon.hide()
		$weapon.user_type = "mob"
		$weapon.modulate = mob_color
	
	# Set attack timer time and connectiom
	$attack_timer.set_wait_time($weapon.get("secondary_as"))


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
