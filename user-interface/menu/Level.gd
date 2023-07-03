extends VBoxContainer

@onready var level := $"../../../background"
@onready var level_list := $LevelList
@onready var preview := $Preview
func select_level(next:bool) -> void:
	if not is_multiplayer_authority():
		return
		
	if next:
		level.current_tab += 1
	else:
		level.current_tab -= 1
	level_list.select(level.current_tab)
	preview.current_tab = level.current_tab
	
	if is_multiplayer_authority():
		rpc("change_level_remote", level.current_tab)

func _on_level_list_item_selected(index:int) -> void:
	if not is_multiplayer_authority():
		return

	level.current_tab = index
	preview.current_tab = index
	
	if is_multiplayer_authority():
		rpc("change_level_remote", index)

@onready var enter := $enter
func _on_enter_pressed() -> void:
	if is_multiplayer_authority():
		rpc("start_game")

@rpc("reliable", "call_local")
func start_game() -> void:
	Global.change_scene(preview.get_current_tab_control().get_meta("level"))
	
@rpc("reliable")
func change_level_remote(idx:int) -> void:
	level.current_tab = idx
	preview.current_tab = idx
	level_list.select(idx)
