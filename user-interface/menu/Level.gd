extends VBoxContainer

@onready var level := $"../../../background"
@onready var level_list := $LevelList
@onready var preview := $Preview
func select_level(next:bool) -> void:
	if next:
		level.current_tab += 1
	else:
		level.current_tab -= 1
	level_list.select(level.current_tab)
	preview.current_tab = level.current_tab

func _on_enter_pressed():
	Global.change_scene(preview.get_current_tab_control().get_meta('level'))
