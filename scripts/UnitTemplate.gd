class_name UnitTemplate
extends Resource

@export var unit_type: String
@export var cost: int
@export var max_health: int
@export var power: int
@export var attack_rate: float # second gap
@export var attack_range: int
@export var texture: Texture2D
@export var bullet_name: String

func _init(d_type = "Unit", d_cost = 1, d_health = 100, d_rate = .75, d_range = 50, d_power = 1, d_texture = Texture2D.new(), bullet: String = "bullet.tscn"):
	unit_type = d_type
	cost = d_cost
	max_health = d_health
	attack_range = d_range
	attack_rate = d_rate
	power = d_power 
	texture = d_texture
	bullet_name = bullet
