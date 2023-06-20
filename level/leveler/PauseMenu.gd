extends ColorRect

@onready var tree := get_tree()
@onready var pause : Button = $"../pause"

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event) -> void:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventScreenTouch:
		show()
		set_process_unhandled_input(false)

func _on_Resume_pressed() -> void:
	tree.paused = false
	pause.show()
	hide()
	set_process_input(true)
	
func _on_Quit_pressed() -> void:
	Global.change_scene(global.lobby)

func _on_restart_pressed():
	Global.restart_scene()

func _on_screen_shoot_pressed():
	hide()
	set_process_unhandled_input(true)

func _on_pause_pressed():
	pause.hide()
	show()
	set_process_input(false)
	accept_event()
	
	if is_instance_valid(Global.player2):
		return
	tree.paused = true
