class_name Bullet
extends Node2D

@export var bullet_speed: float = 500.0

var bullet_owner

func setup(_owner: Node2D):
	bullet_owner = _owner

func _physics_process(delta):
	global_position += transform.x * bullet_speed * delta
