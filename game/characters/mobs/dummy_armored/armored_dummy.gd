# By Jan Domalaon (MaritimesGameworks)

# An armored variant of the test dummy. Has armor resistance.


extends StaticBody2D

var health = 2
var armor = 5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	# Check for death. player_weapons will subtract the health.
	if (health <= 0):
		print(get_name() + ' is deadaz')
		queue_free()
