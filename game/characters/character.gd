extends KinematicBody2D

const FLICKER_TIME = 0.25

# Various stats for characters
export (int) var health = 1
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
# Flickering flag. Can't be hit and can't hit while flickering
var flickering = false
# Check if weapon doesn't only do blunt dmg.
var blunt_hit = false

# Possible movement states for a character
enum State {IDLE, MOVING, ATTACKING, STUNNED}

func _ready():
	$flicker_timer.set_wait_time(FLICKER_TIME)

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
			print("knocking back!")
		if (knockback_counter == 0 && ("bouncy_mobs" in get_groups() && "player" in body.get_groups())):
			# Start knockback counter
			knockback_counter = KNOCKBACK_LENGTH * 2
			knockback_dir = global_transform.origin - body.global_transform.origin
			print("mob knocking back!")
		# Knockback if THIS character touches blunt damage (Player hits mob (this))
		if (knockback_counter == 0 && ("enemies" in get_groups() && "blunt_weapons" in body.get_groups()) && blunt_hit):
			knockback_counter = 10
			knockback_dir = global_transform.origin - body.global_transform.origin
			print("yeet")
			blunt_hit = false

func receive_phys_damage(dmg, dmg_type):
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
