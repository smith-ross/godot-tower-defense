class_name Enemy
extends DamageableEntity

const MONEY = preload("res://scripts/GoldManager.gd")

const FINAL_POS = Vector2(1139, 209)
const MARGIN = 5

var enemy_template: EnemyTemplate

@onready var path: Path2D = get_parent()
@export var enemy_type: String = "Airship"
@export var speed = 50 
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
		area.get_parent().do_hit()
		area.get_parent().explode(self)
		

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
