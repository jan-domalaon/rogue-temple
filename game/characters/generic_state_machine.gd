# Code borrowed from Game Endeavor
# https://www.youtube.com/watch?v=BNU8xNRk_oU

# Interface for State

extends Node
class_name StateMachine

var state = null setget set_state
var previous_state = null
var states: Dictionary = {}

onready var parent = get_parent()


func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

# Virtual State methods to be implemented in specific FSMs
func _state_logic(delta) -> void:
	pass


func _get_transition(delta):
	return null


func _enter_state(new_state, old_state) -> void:
	pass


func _exit_state(old_state, new_state) -> void:
	pass


func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)


# Function to add state when a StateMachine is instantiated
func add_state(state_name):
	states[state_name] = states.size()



