extends VBoxContainer

var keybind :KeyBind

onready var autoshoot := $autoshoot
onready var mouse := $mouse
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
	autoshoot.pressed = Global.config.auto_shoot
	mouse.pressed = Global.config.use_mouse
	
	keybind = load('user://keybind.res')
	if not keybind:
		keybind = KeyBind.new()
		keybind.first_time()
	update_label()

func _exit_tree():
	Global.save_resource('user://keybind.res', keybind)

func update_label():
	var index := 0
	for event in keybind.keybind:
		buttons[0].update_label(keybind.get_event_string(event))
		index += 1

func _on_controls_reset_pressed():
	keybind.reset_bind()
	update_label()

func _on_autoshoot_toggled(button_pressed):
	shoot.disabled = button_pressed
	Global.config.auto_shoot = button_pressed

func _on_mouse_toggled(button_pressed):
	for i in range(0, 4):
		buttons[i].disabled = button_pressed
	Global.config.use_mouse = button_pressed
