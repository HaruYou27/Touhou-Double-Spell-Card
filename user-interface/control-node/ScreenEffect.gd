extends ColorRect
class_name ScreenEffect

func _ready():
	VisualServer.canvas_item_set_z_index(get_canvas_item(), VisualServer.CANVAS_ITEM_Z_MAX)

func fade2black() -> SceneTreeTween:
	show()
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
