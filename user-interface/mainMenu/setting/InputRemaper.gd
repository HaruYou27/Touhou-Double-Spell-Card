extends AnimatedPopup

var index := 0

onready var label :Label = $Label
onready var buttons :Array = $"../../TabContainer/Controls".buttons
onready var keybind :KeyBind = $"../../TabContainer/Controls".keybind

const actions := [
	'ui_left',
	'ui_right',
	'ui_up',
	'ui_down',
	'focus',
	'shoot',
	'bomb',
]
const label_text := [
	'Move left',
	'Move right',
	'Move up',
	'Move down',
	'Shoot',
	'Use bomb',
]

func _ready():
	set_process_input(false)
	for button in buttons:
		button.connect('pressed', self, '_remap', [index])
		index += 1
	
func _input(event):
	if not event is InputEventKey or not event is InputEventJoypadButton or not event is InputEventMouseButton or event.is_action('pause'):
		return
		
	var action :String = actions[index]
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	accept_event()
	visible = false
	set_process_input(false)
	buttons[index].update_label(keybind.get_event_string(event))
	keybind.keybind[action] = event

func _remap(idx:int):
	print(idx)
	index = idx
	label.text = label_text[idx]
	set_process_input(true)
	visible = true

func _on_Cancel_pressed():
	visible = false
	set_process_input(false)
