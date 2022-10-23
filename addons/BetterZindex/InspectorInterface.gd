extends EditorInspectorPlugin

var is_node2d := false
var p_interface := preload("res://addons/BetterZindex/PropertyInterface.gd").new()

func can_handle(object) -> bool:
	is_node2d = object is Node2D
	return is_node2d or object is Control

func parse_property(object, type, path, hint, hint_text, usage):
	if not is_node2d or path != 'z_index':
		return
	add_property
	
func parse_category(object, category):
	if is_node2d or category != 'CanvasItem':
		return
	
