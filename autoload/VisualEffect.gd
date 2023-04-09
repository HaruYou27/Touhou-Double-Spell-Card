extends ColorRect
##Exclusive full screen effect.

var shaking := 0. : set = _shake
func _shake(time:float) -> void:
	shaking += time
	set_process(true)

var current_scene : Node2D
var bgm_volume := 0.

@onready var tree := get_tree()

const black := Color(0.129412, 0.129412, 0.129412)
const black_trans := Color(black, 0.)
const death_scene := preload("res://entity/utility/particle/deathFX.tscn")

func death_vfx(pos:Vector2) -> void:
	var vfx := death_scene.instantiate()
	current_scene.add_child(vfx)
	vfx.global_position = pos
	vfx.emitting = true

func _ready() -> void:
	set_process(false)
	
func _process(delta:float) -> void:
	if shaking <= 0.:
		set_process(false)
		current_scene.position = Vector2.ZERO
		shaking = 0.
	else:
		shaking -= delta
		current_scene.position += Vector2(randf_range(-1., 1.), randf_range(-1., 1.))

##For use with [Tween].
func _set_bgm_volume(value:float) -> void:
	AudioServer.set_bus_volume_db(2, value)

func fade2black(reverse:=false) -> Tween:
	show()
	size = global.game_rect
	
	var tween := create_tween()
	if reverse:
		color = black
		tween.tween_property(self, 'color', black_trans, .5)
		tween.parallel().tween_method(_set_bgm_volume, 0., bgm_volume, .5)
	else:
		bgm_volume = AudioServer.get_bus_volume_db(2)
		color = black_trans
		tween.tween_property(self, 'color', black, .5)
		tween.parallel().tween_method(_set_bgm_volume, bgm_volume, 0., .5)
		
	tween.finished.connect(hide)
	return tween

func flash() -> void:
	show()
	size = global.playground
	color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(self, 'color', Color.TRANSPARENT, .15)
	tween.finished.connect(hide)

func flash_red() -> void:
	show()
	size = global.game_rect
	color = Color(0.996078, 0.203922, 0.203922, 0.592157)
