extends Node2D

func _ready():
	spawn_wave.call_deferred()

func spawn_wave():
	var new_wave: Wave = Wave.new(5, 1)
	new_wave.spawn(get_parent().get_node("EnemyPath"))
