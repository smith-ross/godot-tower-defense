class_name PlaceableButton
extends Button

var template
var hotbar: PlaceableHotbar

func setup(_template, _hotbar: PlaceableHotbar):
	template = _template
	hotbar = _hotbar
	get_node("UnitImage").texture = template.texture
	get_node("CostInfo").get_node("Cost").text = str(template.cost)
	pressed.connect(_on_click)

func _on_click():
	var manager_instance = PlacementManager.get_instance()	
	var target_template = manager_instance.target_template
	if target_template == null or target_template.unit_type != template.unit_type:
		manager_instance.attempt_place(template)
	else:
		manager_instance.clear_target()
		release_focus()
		
