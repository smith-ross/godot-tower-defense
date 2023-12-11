class_name EnemyTemplate
extends Resource

@export var enemy_type: String
@export var health: int
@export var speed: int
@export var reward: int
@export var texture: Texture2D

func _init(d_type = "Airship", d_health = 100, d_speed = 50, d_reward = 5, d_texture = Texture2D.new()):
	enemy_type = d_type
	health = d_health
	speed = d_speed
	reward = d_reward
	texture = d_texture
