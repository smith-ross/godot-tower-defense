class_name Wave
extends Node

var enemy_node = preload("res://nodes/enemy.tscn")
const ENEMY_LIST = [
	preload("res://enemies/airship.tres")
]

var intensity: int = 1
var spawn_rate: float = 1.0;

func _init(_intensity: int = 5, _spawn_rate: float = 1.0):
	intensity = _intensity
	spawn_rate = _spawn_rate
	
func spawn(enemy_path: Path2D):
	for i in range(intensity):
		var new_enemy = enemy_node.instantiate()
		new_enemy.setup(ENEMY_LIST.pick_random())
		enemy_path.add_child(new_enemy)
		await enemy_path.get_tree().create_timer(spawn_rate).timeout
