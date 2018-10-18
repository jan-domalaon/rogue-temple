# By Jan Domalaon

# Shield script. Responsible for its stats, absorbing damage, and its appropriate timers


extends Area2D


export var shield_hp = 5
export var complete_regen_cooldown = 4
export var partial_regen_cooldown = 2
export var regen_time = 0.5
export var shield_name = "Shield (Generic)"

# Upper limit of shield
onready var shield_max_hp = shield_hp

# Signals when shield is disabled
signal shield_broken
signal shield_ready

func _ready():
	# Check if this is a child of a character
	# If so, this shield will be renamed "shield"
	if (get_name() == "shield"):
		# Get shape of the parent knockback_area to use as its shape
		var shield_shape = get_parent().get_node("knockback_area/knockback_hitbox").get_shape()
		$shield_hitbox.set_shape(shield_shape)
		# Set timers
		$partial_regen_timer.set_wait_time(partial_regen_cooldown)
		$complete_regen_timer.set_wait_time(complete_regen_cooldown)
		$shield_regen_timer.set_wait_time(regen_time)

func shield_absorb(dmg, dmg_type):
	if (dmg < shield_hp):
		# Shield is still "up", wait for partial regen timer, then start to regenerate shield hp
		shield_hp = shield_hp - dmg
		$partial_regen_timer.start()
	else:
		# Reset shield hp, so no negative values
		shield_hp = 0
		# Give damage to its parent
		get_parent().receive_phys_damage(dmg - shield_hp, dmg_type)
		# Characters cannot use their shield when their shield is down
		emit_signal("shield_broken")
		# Start complete regen timer
		$complete_regen_timer.start()


func _on_partial_regen_timer_timeout():
	# Start regenrating shield hp
	$shield_regen_timer.start()


func _on_complete_regen_timer_timeout():
	# Shield HP is back to normal
	shield_hp = shield_max_hp
	emit_signal("shield_ready")


func _on_shield_regen_timer_timeout():
	# Regenerate shield HP until shield HP == shield_max_hp
	if (shield_hp < shield_max_hp):
		shield_hp += 1
		$shield_regen_timer.start()
