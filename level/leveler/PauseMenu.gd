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
	Global.change_scene(global.lobby)

func _on_restart_pressed():
	rpc('restart')
	
@rpc("any_peer", "call_local")
func restart() -> void:
	Global.restart_scene()

func _on_pause_pressed():
	show()
	set_process_input(false)
	accept_event()
	
	if is_instance_valid(Global.player2):
		return
	tree.paused = true
