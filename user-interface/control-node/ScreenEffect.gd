extends ColorRect

var shaking := 0.0
var shake_node : Node2D

@onready var tree := get_tree()

const black := Color(0.129412, 0.129412, 0.129412)
const black_trans := Color(black, 0.)

func _ready() -> void:
	hide()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(false)
	Global.bomb_impact.connect(Callable(self,'screen_shake'))

func fade2black(reverse:=false) -> Tween:
	show()
	size = global.game_rect
	var tween := create_tween()
	if reverse:
		color = black
		tween.tween_property(self, 'color', black_trans, .5)
	else:
		color = black_trans
		tween.tween_property(self, 'color', black, .5)
		
	tween.finished.connect(Callable(self,"hide"))
	return tween

func flash() -> void:
	show()
	size = global.playground
	color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color.TRANSPARENT, .15)
	tween.finished.connect(Callable(self,"hide"))

func flash_red() -> void:
	show()
	size = global.game_rect
	color = Color(0.996078, 0.203922, 0.203922, 0.592157)
	
func _process(delta:float) -> void:
	if shaking <= 0.0:
		Global.leveler.position = Vector2.ZERO
		set_process(false)
	else:
		shaking -= delta
		Global.leveler.position += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))

func screen_shake() -> void:
	shaking += .15
	shake_node = tree.current_scene
	set_process(true)
	flash()
