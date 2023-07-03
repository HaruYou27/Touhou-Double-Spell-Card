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

func set_character(_idx:=0) -> void:
	Global.player1 = characters.get_child(characters.current_tab).get_meta('scene').instantiate()
	var id := multiplayer.get_unique_id()
	Global.player1.name = str(id)
	Global.player1.set_multiplayer_authority(id)
	rpc('set_p2_character', characters.current_tab)

@rpc('reliable', "any_peer")
func set_p2_character(index:int) -> void:
	var id := multiplayer.get_remote_sender_id()
	Global.player2 = characters.get_child(index).get_meta('scene').instantiate()
	Global.player2.name = str(id)
	Global.player2.set_multiplayer_authority(id)
