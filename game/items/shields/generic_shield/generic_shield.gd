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
var no_shield_hp = false

# Signals when shield is disabled
signal shield_broken
signal shield_ready


func _ready():
	# Check if this is a child of a character
	# If so, this shield will be renamed "shield"
	$shield_hitbox.set_disabled(true)
	if (get_name() == "shield"):
		# Get shape of the parent knockback_area to use as its shape
		var shield_shape = get_parent().get_node("knockback_area/knockback_hitbox").get_shape()
		$shield_hitbox.set_shape(shield_shape)
		# Set timers
		$partial_regen_timer.set_wait_time(partial_regen_cooldown)
		$complete_regen_timer.set_wait_time(complete_regen_cooldown)
		$shield_regen_timer.set_wait_time(regen_time)


func shield_absorb(dmg, dmg_type):
	print("dmg ", dmg, " shield hp ", shield_hp)
	if (dmg < shield_hp):
		# Shield is still "up", wait for partial regen timer, then start to regenerate shield hp
		shield_hp = shield_hp - dmg
		# Stop other timers, stop regen, start partial timer again
		$complete_regen_timer.stop()
		$shield_regen_timer.stop()
		$partial_regen_timer.start()
	else:
		# Case when shield is completely destroyed (dmg is greater than shield hp)
		get_parent().use_shield(false)
		# Give damage to its parent
		get_parent().receive_phys_damage(dmg - shield_hp, dmg_type)
		# Reset shield hp, so no negative values
		shield_hp = 0
		# Characters cannot use their shield when their shield is down
		emit_signal("shield_broken")
		# Stop partial timer, start complete timer to completely regen shield
		$partial_regen_timer.stop()
		$complete_regen_timer.start()


func _on_partial_regen_timer_timeout():
	# Start regenrating shield hp
	print("partial regen timer done!")
	$shield_regen_timer.start()


func _on_complete_regen_timer_timeout():
	# When regen timer is complete, give full shield HP back
	shield_hp = shield_max_hp
	no_shield_hp = false
	print("complete shield regen!")
	emit_signal("shield_ready")


func _on_shield_regen_timer_timeout():
	# Regenerate shield HP until shield HP == shield_max_hp
	if (shield_hp != shield_max_hp):
		shield_hp += 1
		$shield_regen_timer.start()
	else:
		# Stop regenerating shield.
		$shield_regen_timer.stop()
		$partial_regen_timer.stop()
	print(shield_hp)
