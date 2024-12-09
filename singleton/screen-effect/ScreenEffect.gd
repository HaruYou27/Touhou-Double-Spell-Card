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

func shake(duration:float) -> void:
	set_process(true)
	shake_duration += duration

@onready var shake_intensity: float = Global.user_data.screen_shake_intensity
var noise: FastNoiseLite = preload("res://singleton/screen-effect/noise-cheap.tres")
var shake_duration := 0.0
func _process(delta: float) -> void:
	var scene : Control = LevelLoader.scene
	if shake_duration < 0.0 or shake_intensity < 0.001:
		shake_duration = 0.0
		set_process(false)
		scene.position = Vector2.ZERO
		scene.rotation_degrees = 0.0
	shake_duration -= delta
	
	scene.position.x += noise.get_noise_2d(-Time.get_ticks_msec(), -Time.get_ticks_msec()) * shake_intensity
	scene.position.y += noise.get_noise_2d(Time.get_ticks_msec(), Time.get_ticks_msec()) * shake_intensity
	scene.position = scene.position.clampf(-5.0, 5.0)
	
	scene.rotation_degrees += noise.get_noise_1d(Time.get_ticks_msec())
	scene.rotation_degrees = clampf(scene.rotation_degrees, -0.25, 0.25)
	
func _ready() -> void:
	set_process(false)
	hide()
	# Why does it reset?
	custom_minimum_size = Vector2(540.0, 960.0)
	z_index = 4090
