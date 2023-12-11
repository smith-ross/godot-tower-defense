extends Node2D

const GRID: int = 32

var target: Unit
var rect: Rect2
var valid = false
var placing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	attempt_place(preload("res://units/basic_unit.tres"))

func attempt_place(template: UnitTemplate):
	var new_unit = preload("res://nodes/unit.tscn").instantiate()
	new_unit.unit_template = template
	new_unit.name = "Placeable"
	new_unit.render()
	get_owner().add_child.call_deferred(new_unit)
	target = new_unit
	
func clean_up(new_unit: Unit):
	await get_tree().create_timer(.1).timeout
	var bodies = new_unit.get_node("Area2D").get_overlapping_areas()
	for body in bodies:
		body = body.get_parent()
		if body.is_in_group("path") or body.is_in_group("units"):
			new_unit.queue_free()
			# refund()
			return
	
func place():
	if not valid: return
	var new_unit = preload("res://nodes/unit.tscn").instantiate()
	new_unit.unit_template = target.unit_template
	new_unit.name = "Unit"
	new_unit.global_position = target.global_position
	new_unit.setup()
	get_owner().add_child(new_unit)
	clean_up(new_unit)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and valid:
		place()
	
func _process(_delta):
	if target:
		var text_size = target.get_node("UnitImage").texture.get_size() * target.scale
		var mouse_x: int = int(get_viewport().get_mouse_position().x)
		var mouse_y: int = int(get_viewport().get_mouse_position().y)
		target.global_position = Vector2(mouse_x - (mouse_x % GRID) + (text_size.x), mouse_y - (mouse_y % GRID) + (text_size.y))
		rect = Rect2(Vector2(mouse_x - (mouse_x % GRID), mouse_y - (mouse_y % GRID)), Vector2(GRID, GRID))
		queue_redraw()
		
func _physics_process(_delta):
	if not target: return
	var bodies = target.get_node("Area2D").get_overlapping_areas()
	for body in bodies:
		body = body.get_parent()
		if body.is_in_group("path") or body.is_in_group("units"):
			valid = false
			return
	valid = true

func _draw():
	if rect:
		draw_rect(rect, Color.YELLOW if valid else Color.RED)
