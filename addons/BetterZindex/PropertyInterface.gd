extends EditorProperty

var button := OptionButton.new()
var items :Dictionary
var selected := -1
var current

func _init(current_z_index:int) -> void:
	items = ProjectSettings.get('layer_names/z_index/z_index')
	_update_button()
	label = 'Z Index'
	button.selected = current_z_index
	button.connect("item_selected", self, '_selected_Zindex')

	add_child(button)
	add_focusable(button)
	ProjectSettings.connect("project_settings_changed", self, '_update_button')
	
func _update_button() -> void:
	button.clear()
	
	for key in items.keys():
		if typeof(key) != TYPE_STRING or typeof(items[key]) != TYPE_INT:
			continue
		button.add_item(key)
	
func _selected_Zindex(key) -> void:
	var value = items[button.get_item_text(key)]
	
	if not value:
		return
	
	value = clamp(value, VisualServer.CANVAS_ITEM_Z_MIN, VisualServer.CANVAS_ITEM_Z_MAX)	
	var node := get_edited_object()
	if node is Node2D:
		node.z_index = value
	VisualServer.canvas_item_set_z_index(node.get_canvas_item(), value)
