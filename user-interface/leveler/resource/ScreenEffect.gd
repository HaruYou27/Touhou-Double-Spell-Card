extends ColorRect

@onready var bgm_volume := AudioServer.get_bus_volume_db(2)
@onready var tree := get_tree()

func _ready() -> void:
	Global.player_bombing.connect(flash)

func fade2black(reverse:=false) -> Tween:
	show()
	var tween := create_tween()
	if reverse:
		color = Color.BLACK
		tween.tween_property(self, 'color', Color(Color.BLACK, 0.), .5)
	else:
		bgm_volume = AudioServer.get_bus_volume_db(2)
		color = Color(Color.BLACK, 0.0)
		tween.tween_property(self, 'color', Color.BLACK, 1.)
		
	tween.finished.connect(hide)
	return tween

func flash() -> void:
	show()
	color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color.TRANSPARENT, .3)
	tween.finished.connect(hide)

func flash_red() -> void:
	show()
	color = Color(0.996078, 0.203922, 0.203922, 0.592157)
