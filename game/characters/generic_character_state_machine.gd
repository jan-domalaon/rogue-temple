extends StateMachine 


func _ready():
	add_state("IDLE")
	add_state("MOVING")
	add_state("DEAD")
	call_deferred("set_state", states.IDLE)


func _state_logic(delta) -> void:
	pass


func _get_transition(delta):
	match parent.


func _enter_state(new_state, old_state) -> void:
	pass


func _exit_state(old_state, new_state) -> void:
	pass
