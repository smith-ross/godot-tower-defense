extends Node2D

func _ready():
	spawn_wave.call_deferred()

func spawn_wave():
	var new_wave: Wave = Wave.new(5, 1)
	new_wave.spawn(get_tree().get_root().get_node("MainGame").get_node("EnemyPath"))
