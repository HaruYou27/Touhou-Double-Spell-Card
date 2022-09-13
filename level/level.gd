extends Control
class_name Level

var shaking := 0.0

export (Array) var levels : Array
export (NodePath) var level
export (PackedScene) var stage_scene
export (String) var stage_name

onready var tree = get_tree()
onready var overlayFx := ColorRect.new()
onready var fade := ColorRect.new()
onready var item_get_border :RayCast2D = $Playground/RayCast2D
onready var hud :Sprite = $hud

func _ready() -> void:
	Global.connect('shake', self, 'shake')
	Global.connect("explosive", self, 'flash')
	
	fade.color = Global.fade_black
	hud.add_child(fade)
	var tween := create_tween()
	tween.tween_property(fade, 'color', Global.fade_trans, Global.fade_time)
	tween.connect("finished", hud, 'remove_child', [fade])
	
	remove_child(overlayFx)
	VisualServer.canvas_item_set_z_index(overlayFx.get_rid(), 4000)
	
	level = get_node(level)
	
func save_score() -> void:
	if Global.save_data.assist_mode:
		return
		
	var score = hud.point * hud.graze
	if Global.save_data.hi_score[stage_name] < score:
		Global.save_data.hi_score[stage_name] = score
		Global.save_data.save_data()
	
func _exit_tree() -> void:
	Global.save_data.level = stage_scene

func _physics_process(_delta) -> void:
	if item_get_border.is_colliding():
		ItemManager.autoCollect = true
		
func _process(delta) -> void:
	if shaking <= 0.0:
		rect_position = Vector2(60, 28)
		set_process(false)
	else:
		shaking -= delta
		rect_position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))

func flash() -> void:
	add_child(overlayFx)
	overlayFx.color = Color(1, 1, 1, .5)
	create_tween().tween_property(overlayFx, 'color', Color.transparent, .15)

func shake(duration:float) -> void:
	shaking += duration
	set_process(true)

func next() -> void:
	level.queue_free()
	level = levels.pop_back().instance()
	add_child(level)

func _on_Restart_pressed():
	var tween := create_tween()
	tween.tween_property(fade, 'color', Global.fade_black, Global.fade_time)
	tween.connect("finished", tree, 'change_scene_to', [stage_scene])
