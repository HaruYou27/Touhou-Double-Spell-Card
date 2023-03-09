extends ColorRect

@onready var tree := get_tree()
@onready var resume :Button = $VBoxContainer/Resume
@onready var animator :AnimationPlayer = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("pause"):
		tree.paused = true
		show()
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
	tree.paused = false
	var tween := Global.screenfx.fade2black()
	tween.finished.connect(Callable(tree,'change_scene_to_file').bind("res://user-interface/mainMenu/Menu.tscn"))

