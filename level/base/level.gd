extends Control
class_name Level

var shaking := 0.0
var score_data :Score

export (Array) var levels : Array
export (NodePath) var level
export (PackedScene) var next_scene
export (String) var stage_name

onready var tree = get_tree()
onready var overlay := ColorRect.new()
onready var item_get_border :Area2D = $itemGet
onready var hud :Sprite = $hud

func _ready():
	Rewind.start()
	ItemManager.Clear()
	BulletFx.index = 0
	
	Global.connect("impact", self, 'impact')
	Global.player.connect('die', self, 'flash_red')
	Global.connect("bomb", self, 'remove_child', [overlay])
	Global.connect("next_level", self, 'next')
	Global.config.last_level = tree.current_scene.filename
	
	VisualServer.canvas_item_set_z_index(overlay.get_canvas_item(), 4000)
	var tween := fade2black()
	tween.connect("finished", overlay, 'set_size', [rect_size])
	tween.connect("finished", hud, 'remove_child', [overlay])
	
	stage_name = 'user://%s.res' % stage_name
	score_data = load(stage_name)
	if not score_data:
		score_data = Score.new()
	score_data.retry += 1
	
	level = get_node(level)
	
func _process(delta):
	if shaking <= 0.0:
		rect_position = Vector2(60, 28)
		set_process(false)
	else:
		shaking -= delta
		rect_position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))

func fade2black() -> SceneTreeTween:
	overlay.rect_size = Global.game_rect
	overlay.color = Global.fade_black
	var tween := create_tween()
	tween.tween_property(overlay, 'color', Global.fade_trans, Global.fade_time)
	return tween

func flash_red():
	if tree.paused:
		return
		
	add_child(overlay)
	overlay.color = Color(0.996078, 0.203922, 0.203922, 0.592157)

func impact():
	shaking += .15
	set_process(true)
	
	add_child(overlay)
	overlay.color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(overlay, 'color', Color.transparent, .15)
	tween.connect("finished", self, 'remove_child', [overlay])

func next():
	if levels.size():
		level.queue_free()
		level = levels.pop_back().instance()
		add_child(level)
		return
	
	score_data.add_score(hud, stage_name)
	tree.change_scene_to(next_scene)

func _on_Quit_pressed():
	var tween := fade2black()
	tween.connect("finished", tree, 'change_scene', ["res://user-interface/mainMenu/Menu.scn"])

func _on_itemGet_body_entered(_body):
	ItemManager.autoCollect = true
	ItemManager.keepCollect = true

func _on_itemGet_body_exited(_body):
	ItemManager.keepCollect = false
