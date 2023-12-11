class_name Unit
extends DamageableEntity

enum UnitState {
	INACTIVE,
	IDLE,
	FIRING,
	DESTROYED
}

@export var unit_template: UnitTemplate

var unit_type: String
var unit_state: UnitState = UnitState.INACTIVE
var attack_range: int
var attack_rate: float
var power: int

var is_setup: bool = false
var target: Enemy
var bullet: Resource

var timer: float = 0.0

func render():
	get_node("UnitImage").set_texture(unit_template.texture)

func setup():
	add_to_group("units")
	super._setup(unit_template.max_health)
	unit_type = unit_template.unit_type
	attack_range = unit_template.attack_range
	power = unit_template.power
	attack_rate = unit_template.attack_rate
	bullet = load("res://nodes/" + unit_template.bullet_name)
	render()
	
	died.connect(func(): unit_state = UnitState.DESTROYED)	
	is_setup = true

func round_begin():
	if unit_state != UnitState.DESTROYED:
		unit_state = UnitState.IDLE

func select_target():
	var enemy_list = get_tree().get_nodes_in_group("enemies")
	var closest_enemy: Enemy
	for enemy: Enemy in enemy_list:
		var enemy_dist = global_position.distance_to(enemy.global_position)
		if enemy.state == EntityState.ALIVE and enemy_dist <= attack_range:
			if closest_enemy == null:
				closest_enemy = enemy
			else:
				if global_position.distance_to(closest_enemy.global_position) < enemy_dist:
					closest_enemy = enemy
					
	target = closest_enemy
	if closest_enemy != null:
		unit_state = UnitState.FIRING


func _physics_process(delta):
	if not is_setup: return
	if not target:
		select_target()
	
	if target:
		if self.global_position.distance_to(target.global_position) > attack_range:
			target = null
			unit_state = UnitState.IDLE
			return
		
		look_at(target.global_position)
		rotation -= deg_to_rad(90)
		
		if timer + delta >= attack_rate:
			var new_bullet: Bullet = bullet.instantiate()
			new_bullet.setup(self)
			new_bullet.global_position = get_node("BarrelPosition").global_position
			new_bullet.rotation = rotation + deg_to_rad(90)
			get_tree().get_root().add_child(new_bullet)
		timer = (timer + delta)
		if timer >= attack_rate:
			timer = timer - attack_rate
	
