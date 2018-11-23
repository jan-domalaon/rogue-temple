
extends "res://game/levels/traps/generic_proximity_trap/generic_proximity_trap.gd"


export var damage = 10			# Scale this as the characters enters harder levels


func _on_trap_body_entered(body):
	# Only damage if the trap is not triggered
	if (not triggered):
		if (body.is_in_group("characters")):
			# Trap is triggered
			triggered = true
			# Give physical damage to the character. Pure damage type
			body.receive_phys_damage(damage, "x")
			# Switch textures to indicate that the spikes were triggered
			$trap_sprite.set_region_rect(Rect2(16,0,16,16))
