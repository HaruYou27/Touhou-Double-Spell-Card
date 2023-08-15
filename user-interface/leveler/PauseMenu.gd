extends ColorRect

@onready var tree := get_tree()

func _on_Resume_pressed() -> void:
	tree.paused = false
	hide()
	set_process_input(true)
	
func _on_Quit_pressed() -> void:
	rpc('quit')
	
@rpc("any_peer", "call_local")
func quit() -> void:
	LevelLoader.load_scene(global.main_menu)

func _on_pause_pressed():
	show()
	set_process_input(false)
	accept_event()
	
	if is_instance_valid(Global.player2):
		return
	tree.paused = true
