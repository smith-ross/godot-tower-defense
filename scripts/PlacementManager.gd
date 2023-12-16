class_name PlacementManager
extends Node2D

const GRID: int = 32
const UNITS = [
	preload("res://units/rocket_ravager.tres"),
	preload("res://units/single_shooter.tres")
]
const Hotbar = preload("res://scripts/PlaceableHotbar.gd")

var target: Unit
var target_template: UnitTemplate
var rect: Rect2
var valid = false
var placing = false
var held = false

signal unit_placed(unit)

static var instance

func _init():
	if not instance:
		instance = self
	else:
		self.queue_free()

static func get_instance():
	if not instance:
		instance = PlacementManager.new()
	return instance
	
func _ready():
	unit_placed.connect(func(_unit): if target_template: attempt_place(target_template))

func clear_target(with_template: bool = true):
	if target:
		target.queue_free()
		target = null
		if with_template:
			target_template = null
		queue_redraw()

func attempt_place(template: UnitTemplate):
	clear_target()
	var new_unit = preload("res://nodes/unit.tscn").instantiate()
	new_unit.unit_template = template
	new_unit.name = "Placeable"
	new_unit.render()
	get_owner().add_child.call_deferred(new_unit)
	target = new_unit
	target_template = template
	
	
func clean_up(new_unit: Unit):
	await get_tree().create_timer(.05).timeout
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
	clear_target(false)
	unit_placed.emit(new_unit)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and valid:
		held = true
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		held = false
	
func _process(_delta):
	var hovered = Hotbar.get_instance().is_hovered()
	if target and not hovered:
		var text_size = target.get_node("UnitImage").texture.get_size() * target.scale
		var mouse_x: int = int(get_viewport().get_mouse_position().x)
		var mouse_y: int = int(get_viewport().get_mouse_position().y)
		target.global_position = Vector2(mouse_x - (mouse_x % GRID) + (text_size.x), mouse_y - (mouse_y % GRID) + (text_size.y))
		rect = Rect2(Vector2(mouse_x - (mouse_x % GRID), mouse_y - (mouse_y % GRID)), Vector2(GRID, GRID))
		target.visible = true
	elif target and hovered:
		target.visible = false
		queue_redraw()
		
func valid_check():
	valid = false
	if not target or not target.visible: 
		valid = false
		return
	var bodies = target.get_node("Area2D").get_overlapping_areas()
	for body in bodies:
		body = body.get_parent()
		if body.is_in_group("path") or body.is_in_group("units"):
			valid = false
			return
	valid = true
	
func _physics_process(_delta):
	valid_check()
	if held and valid:
		place()
		valid = false
	queue_redraw()

func _draw():
	if rect and target and target.visible:
		draw_rect(rect, Color.YELLOW if valid else Color.RED)
