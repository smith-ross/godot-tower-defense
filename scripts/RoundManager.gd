class_name RoundManager
extends Node2D

enum RoundState {
	UNINITIALIZED,
	BUILD,
	FIGHT,
	GAME_OVER
}

static var instance

var state: RoundState = RoundState.UNINITIALIZED
var round_difficulty = 0.00

func _init():
	if not instance:
		instance = self
	else:
		queue_free()
		
static func get_instance():
	if not instance:
		instance = RoundManager.new()
	return instance

# After fight is over
func new_round():
	pass
	
func game_over():
	pass
	
# Enter build state
func enter_build():
	pass
	
# Enter fight state
func enter_fight():
	pass
