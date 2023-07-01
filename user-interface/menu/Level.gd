extends VBoxContainer

@onready var level := $"../../../background"
@onready var level_list := $LevelList
func select_level(next:bool) -> void:
	if next:
		level.current_tab += 1
	else:
		level.current_tab -= 1
	level_list.select(level.current_tab)
	
