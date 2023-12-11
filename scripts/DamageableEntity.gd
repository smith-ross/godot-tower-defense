class_name DamageableEntity
extends Node2D

signal health_changed(old_health: int, new_health: int)
signal damaged(damage: int)
signal repaired
signal died

enum EntityState {
	ALIVE,
	DEAD,
	UNINITIALISED
}

var max_health: int
var health: int
var state: EntityState = EntityState.UNINITIALISED

func _setup(_max_health: int):
	add_to_group("damageable_entities")
	max_health = _max_health
	health = max_health 
	state = EntityState.ALIVE
	
	damaged.connect(func(_damage): if health <= 0: kill())

func kill():
	state = EntityState.DEAD
	died.emit()

func take_damage(damage: int):
	var old_health = health
	health -= damage
	if health < 0: health = 0
	damaged.emit(damage)
	health_changed.emit(old_health, health)
	
func heal(heal_amount: int):
	var old_health = health
	health += heal_amount
	if health > max_health: health = max_health
	health_changed.emit(old_health, health)
	
func repair():
	var old_health = health
	health = max_health
	health_changed.emit(old_health, health)
	repaired.emit()
	
