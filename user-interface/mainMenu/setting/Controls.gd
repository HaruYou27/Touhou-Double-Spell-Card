extends VBoxContainer

@onready var drag :UberButton = $drag
@onready var bomb :UberButton = $bomb
@onready var raw :UberButton = $raw
@onready var sentivity :HSlider = $sentivity
@onready var sentivityLabel :FormatLabel = $SentivityLabel

@onready var user_data :UserData = Global.user_data

var switch := false

func _ready():
	if user_data.bomb_bind:
		bomb.update_label(get_input_string(user_data.bomb_bind))
	else:
		bomb.update_label('Mouse Right')
		
	if user_data.drag_bind:
		drag.update_label(get_input_string(user_data.drag_bind))
	else:
		drag.update_label('Mouse Left')
		
	raw.set_pressed_no_signal(user_data.raw_input)
	sentivity.value = user_data.sentivity

func _unhandled_input(event):
	if not event is InputEventMouseButton or not event is InputEventKey:
		return
	
	if switch:
		user_data.drag_bind = event
		drag.update_label(get_input_string(event))
	else:
		user_data.bomb_bind = event
		bomb.update_label(get_input_string(event))
	
	set_process_unhandled_input(false)

func _on_controls_reset_pressed():
	raw.button_pressed = true
	sentivity.value = 1.0
	
	InputMap.action_erase_events('bomb')
	InputMap.action_erase_events('drag')
	
	var b_bind := InputEventMouseButton.new()
	b_bind.button_index = 2
	InputMap.action_add_event('bomb', b_bind)
	
	var d_bind := InputEventMouseButton.new()
	d_bind.button_index = 1
	InputMap.action_add_event('drag', d_bind)
	
	bomb.update_label('Mouse Right')
	drag.update_label('Mouse Left')

static func get_input_string(event:InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_keycode_string(event.keycode)
	
	match event.button_index:
		1:
			return 'Mouse Left'
		2:
			return 'Mouse Right'
		3:
			return 'Mouse Middle'
	
	return 'Unknown'

func _on_bomb_pressed():
	bomb.update_label('Press a button')
	switch = false
	set_process_unhandled_input(true)

func _on_drag_pressed():
	drag.update_label('Press a button')
	switch = true
	set_process_unhandled_input(true)

func _on_sentivity_value_changed(value):
	sentivityLabel.update_label(value)

func _exit_tree():
	user_data.sentivity = sentivity.value
	user_data.raw_input = raw.pressed
	
