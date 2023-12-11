extends Node2D

var enemy_node = preload("res://nodes/enemy.tscn")
const ENEMY_LIST = [
	preload("res://enemies/airship.tres")
]

@export var min_wave_spawn_gap = 1

func _ready():
	wave.call_deferred(5)

func wave(intensity: int):
	for i in range(intensity):
		var new_enemy = enemy_node.instantiate()
		new_enemy.setup(ENEMY_LIST.pick_random())
		get_parent().get_node("EnemyPath").add_child(new_enemy)
		await get_tree().create_timer(1.0 / (float(intensity) / 5.0)).timeout
