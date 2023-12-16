class_name PlaceableHotbar
extends Node

const START_POINT = Vector2(760, 507)
const MARGIN = 10
const PLACEABLE_TEMPLATE = preload("res://nodes/buyable_unit.tscn")	
const UNITS: Array[UnitTemplate] = [
	preload("res://units/single_shooter.tres"),
	preload("res://units/rocket_ravager.tres")
]

@onready var calculated_item_size = Vector2(40,40) * PLACEABLE_TEMPLATE.instantiate().get_scale()
@export var ui: Control
var amount_placed = 0
var placeable_instances = []

static var instance

func _init():
	if not instance:
		instance = self
	else:
		self.queue_free()

static func get_instance() -> PlaceableHotbar:
	if not instance:
		instance = PlaceableHotbar.new()
	return instance

func setup():
	for unit: UnitTemplate in UNITS:
		add_placeable_unit(unit)

func _ready():
	setup.call_deferred()
	
func is_hovered():
	for button in placeable_instances:
		if button.is_hovered():
			return true
	return false

func add_placeable_unit(unit: UnitTemplate):
	var new_instance = PLACEABLE_TEMPLATE.instantiate()
	new_instance.setup(unit, self)
	var previous_position = START_POINT + (Vector2(MARGIN + calculated_item_size.x, 0)) * amount_placed
	amount_placed += 1
	new_instance.global_position = previous_position + Vector2(MARGIN, 0)
	ui.add_child(new_instance)
	placeable_instances.append(new_instance)
