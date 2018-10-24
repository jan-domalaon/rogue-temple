# By Jan Domalaon

# Character script. All mobs, town NPCs, player inherit from this


extends KinematicBody2D

const FLICKER_TIME = 0.25

# Various stats for characters
export (int) var health = 1
export (int) var max_health
export (int) var armor = 0
export (int) var move_speed = 100

# Physical resistance of all characters
var phys_resist = armor * 0.8

# Vars on knockback mechanics
var knockback_counter = 0
var knockback_dir = Vector2(0, 0)
export var knockback_factor = 1.0
const KNOCKBACK_LENGTH = 10

var movement_dir = Vector2(0, 0)
onready var starting_move_speed = move_speed
# Flickering flag. Can't be hit and can't hit while flickering
var flickering = false
# Check if weapon doesn't only do blunt dmg.
var blunt_hit = false
# Shield vars
var has_shield = false
var shield_up = false
var shield_ready = false
# Possible movement states for a character
enum State {IDLE, MOVING, ATTACKING, STUNNED}

# Signals
signal shoot(projectile, direction, location)
signal health_changed(health)


func _ready():
	$flicker_timer.set_wait_time(FLICKER_TIME)
	
	# Check if this character has a shield
	if (has_node("shield")):
		has_shield = true
		$shield/shield_hitbox.set_disabled(true)
		shield_ready = true
		$shield.connect("shield_broken", self, "on_shield_broken")
		$shield.connect("shield_ready", self, "on_shield_ready")
	
	# Max health given when character enters scene
	max_health = health

func _process(delta):
	if (health <= 0):
		print(get_name() + ' is deadaz')
		if (not "player" in get_groups()):
			queue_free()


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


func receive_phys_damage(dmg, dmg_type):
	# Check if the damage given was through walls. No dmg should be given if true
#	var attacker_pos = get_parent().get_node(attacker).get_global_position()
#	var world = get_world_2d().direct_space_state
#	var ignore_areas
#	if ("humanoids" in get_groups()):
#		ignore_areas = [self, $knockback_area]
#	else:
#		ignore_areas = [self, $knockback_area, $weapon]
#	print(attacker_pos)
#	# Ignore mob mask (1101 == 13). Bit mask is in binary
#	var ray = world.intersect_ray(get_global_position(), attacker_pos, [self], 13)
#	#print(ray.collider.get_parent().get_groups())
#	if ("player" in ray.collider.get_parent().get_groups() and get_parent().get_node(attacker).is_in_group("player")):
	
	print("hit!")
	# If the user has a shield and it is up, the shield will absorb dmg
	if (shield_ready and shield_up):
		get_node("shield").shield_absorb(dmg, dmg_type)
	else:
		# Any type of damage should trigger flickering
		flicker()
		# Remove HP from this character based on the damage stat of weapon
		# TODO: Armor reduction formula
		if (dmg_type == 'c'):
			health -= dmg
			print($".".get_name() + " got hit with cut dmg")
		elif (dmg_type == 'p'):
			# Piercing damage. Goes through armor.
			health -= dmg
			print($".".get_name() + " got hit with pierce dmg")
		elif (dmg_type == 'b'):
			# Blunt dmg. Do knockback
			blunt_hit = true
			health -= dmg
			print($".".get_name() + " got hit with blunt dmg")
		emit_signal("health_changed", health)


func flicker():
	# Disable hitboxes
	#$hitbox.set_disabled(true)
	# Disable collision between weapons or other bodies
	$knockback_area/knockback_hitbox.set_disabled(true)
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
		$shield/shield_hitbox.set_disabled(false)
		shield_up = true
		# Disable knockback area
		$knockback_area/knockback_hitbox.set_disabled(true)
		# Slow down movement speed
		move_speed = move_speed * 0.66
	elif (has_shield):
		# The character is not blocking
		# Play animation that brings down shield
		get_node("shield").hide()
		$shield/shield_hitbox.set_disabled(true)
		shield_up = false
		$knockback_area/knockback_hitbox.set_disabled(false)
		# Return move_speed back to normal
		move_speed = starting_move_speed


func on_shield_broken():
	shield_ready = false


func on_shield_ready():
	shield_ready = true