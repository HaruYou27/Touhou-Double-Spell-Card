extends ColorRect
class_name PauseMenu

@onready var tree := get_tree()

func _ready() -> void:
	hide()
	score_label.hide()
	resume.show()

func _on_Quit_pressed() -> void:
	tree.paused = false
	LevelLoader.load_scene(Global.main_menu)

func _on_pause_pressed():
	show()
	set_process_input(false)
	accept_event()
	
	if GlobalItem.is_offline():
		tree.paused = true

func _on_continue_pressed() -> void:
	tree.paused = false
	hide()
	set_process_input(true)

@onready var score_label := $VBoxContainer/score
@onready var resume := $VBoxContainer/Continue
func display_score(score:Score) -> void:
	score_label.show()
	score_label.display_score(score)
	resume.hide()
