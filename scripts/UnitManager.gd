extends Node2D

func _ready():
	var units = get_tree().get_nodes_in_group("units")
	for unit in units:
		unit.setup()
