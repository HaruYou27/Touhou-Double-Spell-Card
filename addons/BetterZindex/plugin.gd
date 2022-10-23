tool
extends EditorPlugin

var plugin := preload("res://addons/BetterZindex/InspectorInterface.gd").new()
const plugin_name := 'layer_names/z_index'

func _enter_tree():
	ProjectSettings.add_property_info({
		'name' : plugin_name,
		'type' : TYPE_DICTIONARY,
	})
	add_inspector_plugin(plugin)

func _exit_tree():
	remove_inspector_plugin(plugin)
	ProjectSettings.clear(plugin_name)
