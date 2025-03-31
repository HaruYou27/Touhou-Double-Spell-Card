extends VBoxContainer

@onready var level := $"../../../background"
@onready var level_list := $LevelList
@onready var preview := $Preview
@onready var user_data: UserData = Global.user_data

func _ready() -> void:
	level.current_tab = user_data.last_level
	level_list.select(user_data.last_level)

func select_level(next:bool) -> void:
	if next:
		level.select_next_available()
	else:
		level.select_previous_available()
	level_list.select(level.current_tab)
	preview.current_tab = level.current_tab

func _on_level_list_item_selected(index:int) -> void:
	if not is_multiplayer_authority():
		return

	level.current_tab = index
	preview.current_tab = index

@onready var enter := $enter
func _on_enter_pressed() -> void:
	user_data.last_level = level.current_tab
	LevelLoader.save_config()
	LevelLoader.load_scene(preview.get_current_tab_control().get_meta("level"), true)
