extends ColorRect
class_name ScreenEffect

var shaking := 0.0

func _ready():
	set_process(false)
	VisualServer.canvas_item_set_z_index(get_canvas_item(), VisualServer.CANVAS_ITEM_Z_MAX)

func fade2black() -> SceneTreeTween:
	show()
	rect_size = Global.game_rect
	color = Color(0.129412, 0.129412, 0.129412)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color(0.129412, 0.129412, 0.129412, 0), .5)
	tween.connect("finished", self, "hide")
	return tween

func flash():
	show()
	color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color.transparent, .15)
	tween.connect("finished", self, 'hide')

func flash_red():
	show()
	color = Color(0.996078, 0.203922, 0.203922, 0.592157)
	
func _process(delta):
	if shaking <= 0.0:
		Global.leveler.position = Vector2(526, 88)
		set_process(false)
	else:
		shaking -= delta
		Global.leveler.position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))

func screen_shake():
	shaking += .15
	set_process(true)
	flash()
