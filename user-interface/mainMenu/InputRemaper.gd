extends PopupDialog

var action :String
var button :AnimatedTextButton

onready var parent := get_parent().get_parent()
onready var label :Label = $Label

func _ready():
	set_process_input(false)
	
func _input(event):
	if not event is InputEventKey or event.is_action('pause'):
		return
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	accept_event()
	visible = false
	set_process_input(false)
	button.update_label(OS.get_scancode_string(event.scancode))
	Global.save_data.key_bind[action] = event.scancode

func _on_left_pressed():
	action = 'ui_left'
	label.text = 'Move Left'
	popup()
	set_process_input(true)
	button = parent.keybind[0]

func _on_right_pressed():
	action = 'ui_right'
	label.text = 'Move Right'
	popup()
	set_process_input(true)
	button = parent.keybind[1]

func _on_up_pressed():
	action = 'ui_up'
	label.text = 'Move Up'
	popup()
	set_process_input(true)
	button = parent.keybind[2]

func _on_down_pressed():
	action = 'ui_down'
	label.text = 'Move Down'
	popup()
	set_process_input(true)
	button = parent.keybind[3]

func _on_focus_pressed():
	action = 'focus'
	label.text = 'Enter Focus Mode'
	popup()
	set_process_input(true)
	button = parent.keybind[4]

func _on_shooting_pressed():
	action = 'shoot'
	label.text = 'Shoot'
	popup()
	set_process_input(true)
	button = parent.keybind[5]

func _on_bomb_pressed():
	action = 'bomb'
	label.text = 'Use bomb'
	popup()
	set_process_input(true)
	button = parent.keybind[6]

func _on_Cancel_pressed():
	visible = false
	set_process_input(false)
