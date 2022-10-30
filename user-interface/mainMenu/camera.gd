extends Camera2D

const ani_length := .15

onready var settings := $"../setting"
onready var characters := $"../character"
onready var levels := $"../level"
onready var main := $"../main"

func _ready():
	only_main()

func only_main():
	settings.hide()
	levels.hide()
	characters.hide()

func _on_settings_pressed():
	var tween := create_tween()
	tween.ween_property(self, 'position', Vector2(-1280, 0), ani_length)
	tween.connect("finished", main, 'hide')

func _on_back_pressed():
	var tween := create_tween()
	tween.tween_property(self, 'position', Vector2.ZERO, ani_length)
	tween.connect("finished", self, 'only_main')

func select_character():
	var tween := create_tween()
	tween.tween_property(self, 'position', Vector2(1280, 0), ani_length)
	tween.connect("finished", main, 'hide')

func select_level():
	var tween := create_tween()
	tween.tween_property(self, 'position', Vector2(2560, 0), ani_length)
	tween.connect("finished", main, 'hide')
	tween.connect("finished", characters, 'hide')
