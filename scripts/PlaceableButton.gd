class_name PlaceableButton
extends Button

var template: UnitTemplate
var hotbar: PlaceableHotbar


func setup(_template: UnitTemplate, _hotbar: PlaceableHotbar):
	template = _template
	hotbar = _hotbar
	get_node("UnitImage").texture = template.texture
	get_node("CostInfo").get_node("Cost").text = str(template.cost)
