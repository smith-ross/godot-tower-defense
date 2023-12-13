class_name Bullet
extends Node2D

const EXPLOSION = preload("res://nodes/bullet_explosion.tscn")

@export var bullet_speed: float = 500.0
@export var explosion_scale: float = 1.0

var bullet_owner
var hit = false

func setup(_owner: Node2D):
	bullet_owner = _owner

func _physics_process(delta):
	global_position += transform.x * bullet_speed * delta

func do_hit():
	hit = true

func explode(victim: Enemy):
	var new_explosion: CPUParticles2D = EXPLOSION.instantiate()
	new_explosion.global_position = global_position + (transform.x * 25)
	new_explosion.scale_amount_min = explosion_scale
	new_explosion.scale_amount_max = explosion_scale
	get_tree().get_root().add_child(new_explosion)
	new_explosion.emitting = true
	victim.take_damage(bullet_owner.power)
	queue_free()
	
	var t = Timer.new()
	t.set_wait_time(new_explosion.lifetime)
	t.set_one_shot(true)
	get_tree().get_root().add_child(t)
	t.start()
	
	await t.timeout
	
	t.queue_free()
	new_explosion.queue_free()
