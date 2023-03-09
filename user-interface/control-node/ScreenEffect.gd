extends ColorRect
class_name ScreenEffect

var shaking := 0.0

func _ready() -> void:
	set_process(false)
	Global.connect("bomb_impact",Callable(self,'screen_shake'))
	Global.screenfx = self

func fade2black() -> Tween:
	show()
	size = Global.game_rect
	color = Color(0.129412, 0.129412, 0.129412)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color(0.129412, 0.129412, 0.129412, 0), .5)
	tween.finished.connect(Callable(self,"hide"))
	return tween

func flash() -> void:
	show()
	color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color.TRANSPARENT, .15)
	tween.finished.connect(Callable(self,"hide"))

func flash_red() -> void:
	show()
	color = Color(0.996078, 0.203922, 0.203922, 0.592157)
	
func _process(delta:float) -> void:
	if shaking <= 0.0:
		Global.leveler.position = Vector2(526, 88)
		set_process(false)
	else:
		shaking -= delta
		Global.leveler.position += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))

func screen_shake() -> void:
	shaking += .15
	set_process(true)
	flash()
