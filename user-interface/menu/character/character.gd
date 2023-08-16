extends VBoxContainer

func _ready() -> void:
	multiplayer.peer_connected.connect(set_character)
	set_character()

@onready var characters := $Preview
@onready var title := $title
func _change_character(next:bool) -> void:
	if next:
		characters.current_tab += 1
	else:
		characters.current_tab -= 1
	title.select(characters.current_tab)
	set_character()

func _on_title_item_selected(index:int) -> void:
	characters.current_tab = index
	set_character()

func set_character() -> void:
	LevelLoader.player1 = characters.get_current_tab_control().get_meta('path')
	LevelLoader.rpc('_set_player2_character', LevelLoader.player1)
