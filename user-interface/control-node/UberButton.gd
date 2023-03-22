extends Button
class_name UberButton

@export var focus_sfx : AudioStream
@export var press_sfx : AudioStream

@onready var template := text
func update_label(value) -> void:
	text = template % value

func _ready() -> void:
	if press_sfx:
		var Focus_sfx := AudioStreamPlayer.new()
		Focus_sfx.stream = focus_sfx
		Focus_sfx.bus = 'SFX'
		mouse_entered.connect(Callable(Focus_sfx,"play"))
		add_child(Focus_sfx)

		var Press_sfx := AudioStreamPlayer.new()
		Press_sfx.stream = press_sfx
		press_sfx.bus = 'SFX'
		pressed.connect(Callable(Press_sfx,"play"))
		add_child(Press_sfx)
		
