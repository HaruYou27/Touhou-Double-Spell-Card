extends VBoxContainer

onready var death_assist :CheckButton = $deathAssist

func _ready():
	death_assist.set_pressed_no_signal(Global.config.death_assist)

func _on_deathAssist_toggled(button_pressed):
	Global.config.death_assist = false
	

