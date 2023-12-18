class_name GoldManager
extends Node2D

static var instance: GoldManager

@export var money_container: Panel
@onready var money_label: Label = money_container.get_node("Amount")
@export var gold: int = 0

signal money_changed(old_money, new_money)
signal money_gained(money_gained)
signal money_lost(money_lost)

func format_money(money: int):
	var rev_money = str(money)
	var i : int = rev_money.length() - 3
	while i > 0:
		rev_money = rev_money.insert(i, ",")
		i = i - 3
	return rev_money

func _init():
	if not instance:
		instance = self
	else:
		self.queue_free()

func _ready():
	money_label.text = format_money(gold)
	money_changed.connect(func(_old_money, _new_money): money_label.text = format_money(gold))
	
static func get_instance():
	if not instance:
		GoldManager.new()
	return instance

func add_money(amount: int):
	var old_amount = gold
	gold += amount
	money_changed.emit(old_amount, gold)
	money_gained.emit(amount)
	
func lose_money(amount: int):
	var old_amount = gold
	gold -= amount
	if gold < 0: gold = 0
	money_changed.emit(old_amount, gold)
	money_lost.emit(old_amount - gold)
