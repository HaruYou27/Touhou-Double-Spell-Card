extends ColorRect
##Exclusive full screen effect.

var shaking := 0. : set = _shake
func _shake(time:float) -> void:
	shaking = time
	set_process(true)

var shake_node : Node2D

@onready var tree := get_tree()

const black := Color(0.129412, 0.129412, 0.129412)
const black_trans := Color(black, 0.)

func _ready() -> void:
	set_process(false)
	
func _process(delta:float) -> void:
	if shaking <= 0.:
		set_process(false)
		shake_node.position = Vector2.ZERO
	else:
		shaking -= delta
		shake_node.position += Vector2(randf_range(-1., 1.), randf_range(-1., 1.))

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
