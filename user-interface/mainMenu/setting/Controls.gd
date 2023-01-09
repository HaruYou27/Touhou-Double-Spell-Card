tool
extends FocusedBoxcontainer

var keybind :KeyBind
onready var config :UserSetting = Global.user_setting

onready var mouse := $mouse
onready var joystick := $joystick
onready var shoot := $shoot
onready var buttons := [
	$left,
	$right,
	$up,
	$down,
	$focus,
	shoot,
	$bomb,
]

func _ready():
	mouse.pressed = config.use_mouse
	
	keybind = load('user://keybind.res')
	if not keybind:
		keybind = KeyBind.new()
		keybind.first_time()
	update_label()

func _exit_tree():
	if not Engine.editor_hint:
		Global.save_resource('user://keybind.res', keybind)

func update_label():
	var i := 0
	for event in keybind.keybind.values():
		buttons[i].update_label(keybind.get_event_string(event))
		i += 1

func _on_controls_reset_pressed():
	keybind.reset_bind()
	update_label()
	mouse.pressed = false
	joystick.pressed = false

func _on_mouse_toggled(button_pressed):
	for i in range(0, 4):
		buttons[i].disabled = button_pressed
	config.use_mouse = button_pressed
	joystick.disabled = button_pressed
	if button_pressed:
		config.auto_shoot = true

func _on_joystick_toggled(button_pressed):
	mouse.disabled = button_pressed
	config.use_joystick = button_pressed
	for i in range(0, 4):
		buttons[i].disabled = button_pressed
	
