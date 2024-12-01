extends ColorRect

@onready var tree := get_tree()

func _ready() -> void:
	hide()

func _on_Quit_pressed() -> void:
	rpc('quit')
	
@rpc("any_peer", "call_local", "reliable")
func quit() -> void:
	tree.paused = false
	LevelLoader.load_scene(Global.main_menu)

func _on_pause_pressed():
	show()
	set_process_input(false)
	accept_event()
	
	if is_instance_valid(Global.player2):
		return
	tree.paused = true

func _on_continue_pressed() -> void:
	tree.paused = false
	hide()
	set_process_input(true)
