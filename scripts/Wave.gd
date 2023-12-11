class_name Wave
extends Node

var enemy_node = preload("res://nodes/enemy.tscn")
const ENEMY_LIST = [
	preload("res://enemies/airship.tres")
]

var intensity: int = 1
var spawn_rate: float = 1.0;
var enemies_remaining: int
var complete: bool = false
var path: Path2D

func _init(_intensity: int = 5, _spawn_rate: float = 1.0):
	intensity = _intensity
	spawn_rate = _spawn_rate
	
func _enemy_died():	
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		complete = true
		Wave.new(intensity + 1, spawn_rate - .2 if spawn_rate > .4 else .2).spawn(path)
		queue_free()
		
func spawn(enemy_path: Path2D):
	path = enemy_path
	enemies_remaining = intensity
	for i in range(intensity):
		var new_enemy = enemy_node.instantiate()
		new_enemy.setup(ENEMY_LIST.pick_random())
		path.add_child.call_deferred(new_enemy)
		new_enemy.died.connect(_enemy_died)
		await path.get_tree().create_timer(spawn_rate).timeout
