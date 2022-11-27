extends AnimatedPopup

var action :String
var button :AnimatedButton
var keybind :KeyBind

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
	keybind.keybind[action] = event

func remap(act:String, text:String):
	label.text = text
	action = act
	set_process_input(true)
	visible = true

func _on_Cancel_pressed():
	visible = false
	set_process_input(false)
