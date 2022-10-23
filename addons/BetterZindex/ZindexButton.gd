extends OptionButton

var index_list :Dictionary = ProjectSettings.get('layer_names/z_index')

func _init():
	_setting_changed()
	ProjectSettings.connect("project_settings_changed", self, '_setting_changed')
	connect("item_selected", self, '_item_selected')

func _setting_changed() -> void:
	clear()
	for item in index_list.keys():
		add_item(item)

func _item_selected(index:int) -> void:
	index_list
