extends PopupPanel

var action :String
var button :AnimatedTextButton

var parent := get_parent()

func _ready():
	set_process_input(false)
	
func _on_cancel_pressed():
	visible = false
	set_process_input(false)

func _input(event):
	if not event is InputEventKey or not event is InputEventMouseButton or event.is_action('pause'):
		return
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	accept_event()
	visible = false
	set_process_input(false)
	button.text = parent.templates[action] % OS.get_scancode_string(event.scancode)

func _on_left_pressed():
	action = 'ui_left'
	visible = true
	set_process_input(true)

func _on_right_pressed():
	action = 'ui_right'
	visible = true
	set_process_input(true)

func _on_up_pressed():
	action = 'ui_up'
	visible = true
	set_process_input(true)

func _on_down_pressed():
	action = 'ui_down'
	visible = true
	set_process_input(true)

func _on_shooting_pressed():
	action = 'shoot'
	visible = true
	set_process_input(true)
	button = parent.shooting

func _on_focus_pressed():
	action = 'focus'
	visible = true
	set_process_input(true)

func _on_bomb_pressed():
	action = 'bomb'
	visible = true
	set_process_input(true)
