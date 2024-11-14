extends VBoxContainer

@onready var raw := $raw
@onready var sentivity := $sentivity
@onready var sentivityLabel := $SentivityLabel

@onready var user_data :UserData = Global.user_data

var switch := false

func _ready() -> void:
	set_process_unhandled_input(false)
	raw.set_pressed_no_signal(user_data.raw_input)
	sentivity.value = user_data.sentivity

func _on_sentivity_value_changed(value:float) -> void:
	sentivityLabel.update_label(value)

func _exit_tree() -> void:
	user_data.sentivity = sentivity.value
	user_data.raw_input = raw.button_pressed
	
func _on_reset_pressed():
	raw.button_pressed = true
	sentivity.value = 1.0
