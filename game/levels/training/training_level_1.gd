extends Node

var level_name = 'Training Level 1'
var level = 1

func _ready():
	# Set level changes
	get_node('YSort/next_level_change').add_to_group('next_level_change')
	get_node('YSort/prev_level_change').add_to_group('prev_level_change')

