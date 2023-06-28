extends Node2D

@onready var characters := $Preview

func _change_character(next:bool) -> void:
	if next:
		characters.current_tab += 1
	else:
		characters.current_tab -= 1

func _exit_tree() -> void:
	Global.player1 = characters.get_child(characters.current_tab).get_meta('scene').instantiate()
	rpc('set_p2_character', characters.current_tab)

@rpc('reliable')
func set_p2_character(idx:int) -> void:
	Global.player2 = characters.get_child(idx).get_meta('scene').instantiate()
