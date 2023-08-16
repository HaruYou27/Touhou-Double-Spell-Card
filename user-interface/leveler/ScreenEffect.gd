extends ColorRect

@onready var bgm_volume := AudioServer.get_bus_volume_db(2)
@onready var tree := get_tree()

## For use with Tween.
func _set_bgm_volume(volume:float) -> void:
	AudioServer.set_bus_volume_db(2, volume)

func fade2black(reverse:=false) -> Tween:
	show()
	var tween := create_tween()
	if reverse:
		color = Color.BLACK
		tween.tween_property(self, 'color', Color(Color.BLACK, 0.), .5)
		tween.parallel().tween_method(_set_bgm_volume, -60.0, bgm_volume, .5)
	else:
		bgm_volume = AudioServer.get_bus_volume_db(2)
		color = Color(Color.BLACK, 0.0)
		tween.tween_property(self, 'color', Color.BLACK, 1.)
		tween.parallel().tween_method(_set_bgm_volume, bgm_volume, -60.0, 1.)
		tween.tween_property(self, 'color', Color(Color.BLACK, 0.), .5)
		tween.parallel().tween_method(_set_bgm_volume, -60.0, bgm_volume, .5)
		
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
