extends ColorRect

@onready var tree := get_tree()
@onready var animator :AnimationPlayer = $AnimationPlayer
@onready var pause : Button = $"../pause"

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event) -> void:
	if event is InputEventAction:
		animator.play("show")
		set_process_unhandled_input(false)

func _on_Resume_pressed() -> void:
	tree.paused = false
	pause.show()
	animator.play('hide')
	set_process_input(true)
	Engine.time_scale = Global.score.game_speed
	
func _on_Quit_pressed() -> void:
	Global.change_scene(preload("res://user-interface/mainMenu/Menu.tscn"))

func _on_restart_pressed():
	Global.restart_scene()

func _on_screen_shoot_pressed():
	animator.play("hide")
	set_process_unhandled_input(true)

func _on_pause_pressed():
	pause.hide()
	tree.paused = true
	animator.play('show')
	set_process_input(false)
	accept_event()
	Engine.time_scale = 1.0
