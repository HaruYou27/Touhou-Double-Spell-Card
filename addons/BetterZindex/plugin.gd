tool
extends EditorPlugin

var plugin := preload("res://addons/BetterZindex/InspectorInterface.gd").new()
const plugin_name := 'layer_names/z_index/z_index'

func _enter_tree():
	add_inspector_plugin(plugin)
	
	if ProjectSettings.has_setting(plugin_name):
		return
	ProjectSettings.set_setting(plugin_name, {'Not Set' : 0})
	ProjectSettings.add_property_info({
		'name' : plugin_name,
		'type' : TYPE_DICTIONARY,
	})
	ProjectSettings.set_initial_value(plugin_name, {})
	ProjectSettings.save()

func _exit_tree():
	remove_inspector_plugin(plugin)
