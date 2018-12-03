extends "res://game/characters/mobs/generic_mob/new_generic_mob.gd"


func _ready():
	$attack_timer.set_wait_time($weapon.get("secondary_as"))


