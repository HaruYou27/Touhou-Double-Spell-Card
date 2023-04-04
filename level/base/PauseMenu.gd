extends ColorRect

@onready var tree := get_tree()
@onready var resume :Button = $VBoxContainer/Resume
@onready var animator :AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event) -> void:
	animator.play("show")
	set_process_unhandled_input(false)

func _pause() -> void:
	tree.paused = true
	animator.play('show')
	resume.call_deferred('set_disabled', false)
	set_process_input(false)
	accept_event()
	Engine.time_scale = 1.0

func _on_Resume_pressed() -> void:
	resume.disabled = true
	tree.paused = false
	animator.play('hide')
	set_process_input(true)
	Engine.time_scale = Global.score.game_speed
	
func _on_Quit_pressed() -> void:
	Global.change_scene("res://user-interface/mainMenu/Menu.tscn")

func _on_restart_pressed():
	Global.restart_scene()

func _on_screen_shoot_pressed():
	animator.play("hide")
	set_process_unhandled_input(true)
