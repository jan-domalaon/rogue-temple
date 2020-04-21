# By Jan Domalaon

# Character script. All mobs, town NPCs, player inherit from this


extends KinematicBody2D

const FLICKER_TIME = 0.25

# Various stats for characters
export (float) var health = 1
export (float) var max_health = 100
export (int) var armor = 0
export (int) var move_speed = 100
export (String) var character_name = "Character"

# Physical resistance of all characters
var phys_resist = armor * 0.8

# Vars on knockback mechanics
var knockback_counter = 0
var knockback_dir = Vector2(0, 0)
export var knockback_factor = 1.0
const KNOCKBACK_LENGTH = 10

var movement_dir = Vector2(0, 0)
onready var starting_move_speed = move_speed
# Can change when buffed
onready var max_move_speed = move_speed
# Flickering flag. Can't be hit and can't hit while flickering
var flickering = false
# Check if weapon doesn't only do blunt dmg.
var blunt_hit = false
# Shield vars
var has_shield = false
var shield_up = false
var shield_ready = false

# Flag for pitfall trap
var pitfall = false

# Possible movement states for a character
enum State {IDLE, MOVING, ATTACKING, STUNNED}

# For "weapon hitting chars through wall"/weapon raycast detection
onready var world_space = get_world_2d().direct_space_state
onready var raycast_ignore_areas = [self, $knockback_area]

# Signals
signal shoot(projectile, direction, location)
signal health_changed(health)

# Game log signals
signal opened_door(user_name)
signal character_damaged(victim_name, dmg, dmg_type)
signal character_died(victim_name)
signal character_pitfallen(victim_name)

# Death screen signal
signal player_died


func _ready():
	$flicker_timer.set_wait_time(FLICKER_TIME)
	
	# Check if this character has a shield
	if (has_node("shield")):
		connect_shield()
	emit_signal("health_changed", health)
	
	print("character.gd health " + str(health))


func movement():
	var motion
	if (knockback_counter == 0):
		motion = movement_dir.normalized() * move_speed
	else:
		motion = knockback_dir.normalized() * 100
	move_and_slide(motion, Vector2(0, 0))


func knockback():
	# Knockback countdown
	if (knockback_counter > 0):
		knockback_counter -= 1
	for area in $knockback_area.get_overlapping_areas():
		var body = area.get_parent()
		# Knockback if THIS character is an enemy and touches a player
		if (knockback_counter == 0 && ("player" in get_groups() && "bouncy_mobs" in body.get_groups())):
			# Start knockback counter
			knockback_counter = KNOCKBACK_LENGTH
			knockback_dir = global_transform.origin - body.global_transform.origin
			flicker()
			#print("knocking back!")
		if (knockback_counter == 0 && ("bouncy_mobs" in get_groups() && "player" in body.get_groups())):
			# Start knockback counter
			knockback_counter = KNOCKBACK_LENGTH * 2
			knockback_dir = global_transform.origin - body.global_transform.origin
			#print("mob knocking back!")
		# Knockback if THIS character touches blunt damage (Player hits mob (this))
		if (knockback_counter == 0 && ("enemies" in get_groups() && "blunt_weapons" in body.get_groups()) && blunt_hit):
			knockback_counter = 10
			knockback_dir = global_transform.origin - body.global_transform.origin
			blunt_hit = false
		# Knockback player if THIS character hits the player with a blunt weapon
		if (knockback_counter == 0 && ("player" in get_groups() && "blunt_weapons" in body.get_groups()) && blunt_hit):
			knockback_counter = 10
			knockback_dir = global_transform.origin - body.global_transform.origin
			blunt_hit = false


func receive_phys_damage(dmg, dmg_type):
	# If the user has a shield and it is up, the shield will absorb dmg
	# If damage is pure, goes through damage
	if (shield_ready and shield_up and dmg_type != "x"):
		get_node("shield").shield_absorb(dmg, dmg_type)
	else:
		# Any type of damage should trigger flickering
		flicker()
		# Remove HP from this character based on the damage stat of weapon
		# Armor reduction formula: (dmg * multiplier) / (armor + 1) (at most, the damage dealt is the weapon's flat damage)
		if (dmg_type == 'c'):
			health -= ((dmg * 2) / (armor + 1))
			print($".".get_name() + " got hit with cut dmg for " + str(((dmg * 2 ) / (armor + 1))) + " dmg")
		elif (dmg_type == 'p'):
			# Piercing damage. Goes through armor.
			health -= dmg
			print($".".get_name() + " got hit with pierce dmg")
		elif (dmg_type == 'b'):
			# Blunt dmg. Do knockback
			blunt_hit = true
			health -= ((dmg * 3) / (armor + 1))
			print($".".get_name() + " got hit with blunt dmg for " + str(((dmg * 2 ) / (armor + 1))) + " dmg")
		elif (dmg_type == 'x'):
			# Pure damage
			health -= dmg
			print($".".get_name() + " got hit with pure dmg for " + str(dmg))
		
		# Emit signals for game log
		emit_signal("character_damaged", character_name, dmg, dmg_type)
		
		# Character is dead
		if (health <= 0):
			print(get_name() + ' is dead!')
			# Emit death message to game log
			emit_signal("character_died", character_name)
			set_process(false)
			set_physics_process(false)
			$hitbox.call_deferred("set_disabled", true)
			if (not is_in_group("player")):
				# This character is a mob. Play death animation, disable physics and free from memory
				if (is_in_group("enemies")):
					# Disable healthbar
					$mob_health_bar.hide()
				if (is_in_group("humanoids")):
					# Hide weapon
					$weapon.hide()
					if health <= 0:
						emit_signal("enemy_died")
				$animation_player.play("character_death")
			else:
				# Player has died
				# Turn off player input to player node
				# Play death animation
				$animation_player.play("player_death")
				emit_signal("health_changed", 0)
				emit_signal("player_died")
				set_process_input(false)
				# Show death screen, pause game


func flicker():
	# Disable hitboxes
	#$hitbox.set_disabled(true)
	# Disable collision between weapons or other bodies
	$knockback_area/knockback_hitbox.call_deferred("set_disabled", true)
	$animation_player.play("flicker")
	$flicker_timer.start()
	flickering = true


func _on_flicker_timer_timeout():
	# Enable collisions
	#$hitbox.set_disabled(false)
	$knockback_area/knockback_hitbox.set_disabled(false)
	flickering = false


# Handles shield appearance and knockback collision logic wrt shields
func use_shield(blocking):
	# Check if this character has a shield first
	if (has_shield and blocking):
		# "Turn on" shield
		get_node("shield").show()
		$shield/shield_hitbox.call_deferred("set_disabled", false)
		shield_up = true
		# Disable knockback area
		$knockback_area/knockback_hitbox.call_deferred("set_disabled", true)
		# Slow down movement speed
		move_speed = move_speed * 0.66
	elif (has_shield):
		# The character is not blocking
		# Play animation that brings down shield
		get_node("shield").hide()
		$shield/shield_hitbox.call_deferred("set_disabled", true)
		shield_up = false
		$knockback_area/knockback_hitbox.call_deferred("set_disabled", false)
		# Return move_speed back to normal
		move_speed = starting_move_speed


func on_shield_broken():
	shield_ready = false


func on_shield_ready():
	shield_ready = true


func connect_shield():
	# Connect this character's shield to shield functions of character
	has_shield = true
	$shield/shield_hitbox.set_disabled(true)
	shield_ready = true
	$shield.connect("shield_broken", self, "on_shield_broken")
	$shield.connect("shield_ready", self, "on_shield_ready")


func on_pitfall():
	# Plays when the character enters a pit trap area (crevice, false trapdoor, etc.)
	
	# Disable processes and hitbox
	$hitbox.set_disabled(true)
	set_process_input(false)
	set_process(false)
	set_physics_process(false)
	
	pitfall = true
	
	# Print message in game log
	emit_signal("character_pitfallen", character_name)
	
	# Play fall anim
	if is_in_group("player"):
		$animation_player.play("player_fall_anim")
	else:
		$animation_player.play("fall_anim")


func get_effect(effect_name):
	pass
