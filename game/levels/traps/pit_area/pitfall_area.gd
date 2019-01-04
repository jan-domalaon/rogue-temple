# Pitfall trap area. When player enters here, they fall to the next level


extends Area2D


export (String) var next_level = ""


func _ready():
	pass


func _on_pit_area_body_entered(body):
	# If a character enters the pitfall, send to pitfall save
	if (body.is_in_group("characters")):
		body.on_pitfall()