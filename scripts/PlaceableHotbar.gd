class_name PlaceableHotbar
extends Node

const START_POINT = Vector2(760, 507)
const MARGIN = 10
const PLACEABLE_TEMPLATE = preload("res://nodes/buyable_unit.tscn")	

@onready var calculated_item_size = Vector2(40,40) * PLACEABLE_TEMPLATE.instantiate().get_scale()
@export var ui: Control
var amount_placed = 0

class Placeable:
	var unit: UnitTemplate
	
	func _init(_unit: UnitTemplate):
		unit = _unit
		
	func create():
		var new_placeable = PLACEABLE_TEMPLATE.instantiate()
		new_placeable.get_node("UnitImage").texture = unit.texture
		new_placeable.get_node("CostInfo").get_node("Cost").text = str(unit.cost)
		
		return new_placeable
	

func _ready():
	add_placeable_unit(load("res://units/single_shooter.tres"))
	add_placeable_unit(load("res://units/rocket_ravager.tres"))

func add_placeable_unit(unit: UnitTemplate):
	var unit_placeable = Placeable.new(unit)
	var instance = unit_placeable.create()
	var previous_position = START_POINT + (Vector2(MARGIN + calculated_item_size.x, 0)) * amount_placed
	amount_placed += 1
	instance.global_position = previous_position + Vector2(MARGIN, 0)
	ui.add_child(instance)
