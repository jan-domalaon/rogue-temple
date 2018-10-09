extends "res://game/characters/mobs/generic_mob/generic_mob.gd"

func _physics_process(delta):
	knockback()

func _on_knockback_area_body_entered(body):
	if ("player" in body.get_groups()):
		body.flicker()