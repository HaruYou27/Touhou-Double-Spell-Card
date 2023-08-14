extends ColorRect
class_name ScreenEffect
##Exclusive full screen effect.

var current_scene : Node
@onready var bgm_volume := AudioServer.get_bus_volume_db(2)
@onready var tree := get_tree()

func _ready() -> void:
	current_scene = tree.current_scene
	Global.screen_effect = self

func restart_level() -> void:
	fade2black().finished.connect(tree.reload_current_scene)

func fade2black(reverse:=false) -> Tween:
	show()
	size = global.game_rect
	
	var tween := create_tween()
	if reverse:
		color = Color.BLACK
		tween.tween_property(self, 'color', Color(Color.BLACK, 0.), .5)
		tween.parallel().tween_method(AudioServer.set_bus_volume_db, -60.0, bgm_volume, .5)
	else:
		bgm_volume = AudioServer.get_bus_volume_db(2)
		color = Color(Color.BLACK, 0.0)
		tween.tween_property(self, 'color', Color.BLACK, 1.)
		tween.parallel().tween_method(AudioServer.set_bus_volume_db, bgm_volume, -60.0, 1.)
		
	tween.finished.connect(hide)
	return tween

func flash() -> void:
	show()
	color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color.TRANSPARENT, .15)
	tween.finished.connect(hide)

func flash_red() -> void:
	show()
	color = Color(0.996078, 0.203922, 0.203922, 0.592157)
