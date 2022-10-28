extends EditorProperty

var index_button := OptionButton.new()
var items :Dictionary
var selected := -1

func _init() -> void:
	items = ProjectSettings.get('layer_names/z_index/z_index')
	_update_button()
	index_button.connect("item_selected", self, '_selected_Zindex')
	label = 'Z Index'

	add_child(index_button)
	add_focusable(index_button)
	ProjectSettings.connect("project_settings_changed", self, '_update_button')
	
func _update_button() -> void:
	index_button.clear()
	
	for key in items.keys():
		if typeof(key) != TYPE_STRING or typeof(items[key]) != TYPE_INT:
			continue
		index_button.add_item(key)
	
func _selected_Zindex(key) -> void:
	var value = items[index_button.get_item_text(key)]
	
	if not value:
		return
	
	var node := get_edited_object()
	print(node)
	if node is Node2D:
		node.z_index = value
		
	VisualServer.canvas_item_set_z_index(node.get_canvas_item(), value)
