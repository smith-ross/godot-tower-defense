class_name Enemy
extends DamageableEntity

const MONEY = preload("res://scripts/GoldManager.gd")

const FINAL_POS = Vector2(1139, 209)
const MARGIN = 5

var bullet_explosion = preload("res://nodes/bullet_explosion.tscn")
var enemy_template: EnemyTemplate

@onready var path: Path2D = get_parent()
@export var enemy_type: String = "Airship"
@export var speed = 50 # tie this to an EnemyTemplate Resource eventually like already doing for units
@export var money_per_kill = 5

var points
var current_point = 0

func _ready():
	add_to_group("enemies")
	points = []
	for i in range(path.curve.point_count):
		points.append(path.curve.get_point_position(i))
	global_position = points[current_point]
	current_point += 1
	
	died.connect(_on_die)
	$Area2D.area_entered.connect(area_entered)

func _on_die():
	MONEY.get_instance().add_money(money_per_kill)
	queue_free()

func area_entered(area: Area2D):
	if area.get_parent().is_in_group("bullet") and not area.get_parent().hit:
		area.get_parent().hit = true
		var new_explosion: CPUParticles2D = bullet_explosion.instantiate()
		new_explosion.global_position = area.get_parent().global_position + (area.get_parent().transform.x * 25)
		get_tree().get_root().add_child(new_explosion)
		new_explosion.emitting = true
		take_damage(area.get_parent().bullet_owner.power)
		area.get_parent().queue_free()
		
		var t = Timer.new()
		t.set_wait_time(new_explosion.lifetime)
		t.set_one_shot(true)
		get_tree().get_root().add_child(t)
		t.start()
		
		await t.timeout
		
		t.queue_free()
		new_explosion.queue_free()
		

func render():
	get_node("EnemyImage").set_texture(enemy_template.texture)

func setup(template: EnemyTemplate):
	super._setup(template.health)
	enemy_template = template
	
	enemy_type = enemy_template.enemy_type
	speed = enemy_template.speed
	money_per_kill = enemy_template.reward
	render()

func _physics_process(delta):
	if state == EntityState.DEAD:
		return
	if len(points) <= current_point:
		global_position = points[0] # reached the end
		current_point = 1
	look_at(points[current_point])
	position += transform.x * speed * delta
	if position.distance_to(points[current_point]) <= MARGIN:
		current_point += 1 
