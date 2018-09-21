extends Area2D

var weapon_name = 'Iron Mace'
var primary_dmg = 3
var secondary_dmg = 2
var weight = 5
var weapon_type = 'blunt'
var primary_as = 0.6
var secondary_as = 0.3



func _on_iron_mace_body_entered(body):
	# Get deliver_damage function from weapon_action
	# Only when player is wielding this
	pass
