extends Button
class_name UberButton

@export (AudioStream) var focus_sfx
@export (AudioStream) var press_sfx

@onready var template := text
func update_label(value):
	text = template % value

func _ready():
	if press_sfx:
		var Focus_sfx := AudioStreamPlayer.new()
		Focus_sfx.stream = focus_sfx
		connect("mouse_entered",Callable(Focus_sfx,"play"))
		add_child(Focus_sfx)

		var Press_sfx := AudioStreamPlayer.new()
		Press_sfx.stream = press_sfx
		connect("pressed",Callable(Press_sfx,"play"))
		add_child(Press_sfx)
