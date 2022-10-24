extends EditorInspectorPlugin

var p_interface := preload("res://addons/BetterZindex/PropertyInterface.gd")

func can_handle(object) -> bool:
	return object is Node2D or object is Control

func parse_category(object, category):
	if category != 'CanvasItem':
		return false
		
	add_property_editor(category, p_interface.new())
	return true
