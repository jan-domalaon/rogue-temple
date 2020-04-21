# By Jan Domalaon (MaritimesGameworks)

extends KinematicBody2D

# An unarmored test dummy.

# TODO: Bug: The player can hit the enemy twice by getting out of the hitbox and re-entering it again.

var health = 2
var armor = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	# Check for death. player_weapons will subtract the health.
	if (health <= 0):
		print(get_name() + ' is deadaz')
		queue_free()
