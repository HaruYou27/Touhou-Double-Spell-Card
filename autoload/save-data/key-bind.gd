extends Resource
class_name KeyBind

export (Dictionary) var keybind := {
	'ui_left' : null,
	'ui_right' : null,
	'ui_up' : null,
	'ui_down' : null,
	'focus' : null,
	'shoot' : null,
	'bomb' : null,
}
export (Dictionary) var default_bind := keybind.duplicate(true)

func load_bind():
	for action in keybind.keys():
		var event = keybind[action]
		if not event:
			continue
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		
func reset_bind():
	reset_dictionary()
		
	for action in default_bind.keys():
		InputMap.action_erase_events(action)
		for event in InputMap.get_action_list(action):
			InputMap.action_add_event(action, event)

func first_time():
	for action in default_bind.keys():
		default_bind[action] = InputMap.get_action_list(action)
	reset_dictionary()
		
func reset_dictionary():
	for action in keybind.keys():
		keybind[action] = default_bind[action][0]
		
static func get_event_string(event:InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_scancode_string(event.scancode)
	elif event is InputEventJoypadButton:
		return Input.get_joy_button_string(event.button_index)
	elif event is InputEventMouseButton:
		return get_mouse_button_string(event.button_index)
	return 'Unknown'
	
static func get_mouse_button_string(index:int) -> String:
	match index:
		1:
			return 'Mouse Button Left'
		2:
			return 'Mouse Button Right'
		3:
			return 'Mouse Button Middle'
		4:
			return "Mouse Wheel Up"
		5:
			return "Mouse Wheel Down"

	return 'Unknow Mouse Button'
