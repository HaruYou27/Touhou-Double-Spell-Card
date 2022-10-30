extends Button
class_name SFXButton

onready var focus_fx := AudioStreamPlayer.new()
onready var press_fx := AudioStreamPlayer.new()

func _ready() -> void:
	focus_fx.bus = 'SFX'
	press_fx.bus = 'SFX'
	add_child(focus_fx)
	add_child(press_fx)
	
	connect("focus_entered", focus_fx, "play")
	connect("mouse_entered", focus_fx, 'play')
	connect("pressed", press_fx, 'play')
