extends VBoxContainer

@onready var hold := $hold
@onready var drag := $drag
@onready var bomb := $bomb
@onready var raw := $raw
@onready var sentivity := $sentivity
@onready var sentivityLabel := $SentivityLabel

@onready var user_data :UserData = Global.user_data

var switch := false

func _ready() -> void:
	bomb.update_label(global.get_input_string(user_data.bomb_bind))
	var drag_name := global.get_input_string(user_data.drag_bind)
	drag.update_label(drag_name)
	hold.update_label(drag_name)
	
	raw.set_pressed_no_signal(user_data.raw_input)
	sentivity.value = user_data.sentivity

func _unhandled_input(event:InputEvent) -> void:
	if not (event is InputEventMouseButton or event is InputEventKey):
		return
	
	if switch:
		user_data.drag_bind = event
		var event_name := global.get_input_string(event)
		drag.update_label(event_name)
		hold.update_label(event_name)
	else:
		user_data.bomb_bind = event
		bomb.update_label(global.get_input_string(event))
	
	set_process_unhandled_input(false)

func _on_bomb_pressed() -> void:
	bomb.update_label('Press a button')
	switch = false
	set_process_unhandled_input(true)
	
func _on_hold_toggled(button_pressed:bool) -> void:
	drag.visible = button_pressed
	user_data.hold_move = button_pressed
	
func _on_drag_pressed() -> void:
	drag.update_label('Press a button')
	switch = true
	set_process_unhandled_input(true)

func _on_sentivity_value_changed(value:float) -> void:
	sentivityLabel.update_label(value)

func _exit_tree() -> void:
	user_data.sentivity = sentivity.value
	user_data.raw_input = raw.button_pressed
	
func _on_reset_pressed():
	raw.button_pressed = true
	sentivity.value = 1.0
	InputMap.load_from_project_settings()
	bomb.update_label(global.get_input_string(user_data.bomb_bind))
	drag.update_label(global.get_input_string(user_data.drag_bind))
