extends ColorRect

@onready var bgm_volume := AudioServer.get_bus_volume_db(2)
@onready var tree := get_tree()

func fade2black(reverse:=false) -> Tween:
	tree.paused = false
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

func flash(duration:float) -> void:
	show()
	color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color.TRANSPARENT, duration)
	tween.finished.connect(hide)

func flash_red() -> void:
	show()
	color = Color(0.996078, 0.203922, 0.203922, 0.592157)
	
func _ready() -> void:
	set_process(false)
	hide()
	# Why does it reset?
	custom_minimum_size = Vector2(540.0, 960.0)
	z_index = 4090
