extends ColorRect

@onready var tree := get_tree()
@onready var resume :Button = $VBoxContainer/Resume
@onready var animator :AnimationPlayer = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		tree.paused = true
		animator.play('show')
		resume.call_deferred('set_disabled', false)
		set_process_input(false)
		accept_event()
		Engine.time_scale = 1.0

func _on_Resume_pressed():
	resume.disabled = true
	tree.paused = false
	animator.play('hide')
	set_process_input(true)
	Engine.time_scale = Global.score.game_speed
	
func _on_Quit_pressed() -> void:
	Global.change_scene("res://user-interface/mainMenu/Menu.tscn")

func _on_restart_pressed():
	Global.restart_scene()
