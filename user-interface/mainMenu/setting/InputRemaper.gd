extends AnimatedPopup

var index := 0

onready var label :Label = $Label
onready var buttons :Array = $"../../TabContainer/Controls".buttons
onready var keybind :KeyBind = $"../../TabContainer/Controls".keybind
onready var parent :CanvasLayer = get_parent()

const ani_duration := .15

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
	if not event is InputEventKey or not event is InputEventJoypadButton or event.is_action('pause'):
		return
		
	var action :String = actions[index]
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	accept_event()
	buttons[index].update_label(keybind.get_event_string(event))
	keybind.keybind[action] = event
	
	_on_Cancel_pressed()

func _remap(idx:int):
	index = idx
	label.text = label_text[idx]
	
	set_process_input(true)
	parent.show()
	show()
	create_tween().tween_property(self, 'rect_scale', Vector2.ONE, ani_duration)

func _on_Cancel_pressed():
	var tween := create_tween()
	tween.tween_property(self, 'rect_scale', Vector2(.1, .1), ani_duration)
	tween.connect("finished", parent, 'hide')
	tween.connect("finished", self, 'hide')
	set_process_input(false)
