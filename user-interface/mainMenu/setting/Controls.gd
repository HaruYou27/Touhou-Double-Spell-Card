extends VBoxContainer

onready var drag :UberButton = $drag
onready var bomb :UberButton = $bomb

onready var user_setting :UserSetting = Global.user_setting

var switch := false



func _unhandled_input(event):
	if not event is InputEventMouseButton or not event is InputEventKey:
		return
	
	if switch:
		user_setting.drag_bind = event
		drag.update_label(get_input_string(event))
	else:
		user_setting.bomb_bind = event
		bomb.update_label(get_input_string(event))

func _on_controls_reset_pressed():
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

func get_input_string(event:InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_scancode_string(event.scancode)
	
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

func _on_drag_pressed():
	drag.update_label('Press a button')
	switch = true

func _on_raw_toggled(button_pressed):
	user_setting.raw_input = button_pressed
