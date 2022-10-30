extends EditorInspectorPlugin

var p_interface := preload("res://addons/BetterZindex/PropertyInterface.gd")

func can_handle(object) -> bool:
	return object is CanvasItem

func parse_category(object, category):
	if category != 'CanvasItem':
		return false
	
	var current := -1
	if object is Node2D:
		current = ProjectSettings.get('layer_names/z_index/z_index').values().find(object.z_index)
	
	add_property_editor(category, p_interface.new(current))
	return true
