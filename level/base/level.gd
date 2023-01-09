extends Control
class_name Level

var shaking := 0.0
var score_data :Score
var rewind

export (Array) var levels : Array
export (NodePath) var level
export (PackedScene) var next_scene
export (String) var stage_name

onready var tree = get_tree()
onready var hud :Sprite = $hud
onready var screenfx :ScreenEffect = $hud/ScreenEffect
onready var item_manager := $ItemManager
onready var config :UserSetting = Global.user_setting

func _ready():
	Global.user_setting.last_level = tree.current_scene.filename
	Global.connect("bomb_impact", self, 'screen_shake')
	
	if config.rewind:
		rewind = preload("res://level/base/recorder/Recorder.scn").instance()
		add_child(rewind)
	
	var tween := screenfx.fade2black()
	tween.connect("finished", screenfx, 'set_size', [rect_size])
	
	stage_name = 'user://%s.res' % stage_name
	score_data = load(stage_name)
	if not score_data:
		score_data = Score.new()
	score_data.retry += 1
	
	level = get_node(level)
	Global.level = self
	
func _process(delta):
	if shaking <= 0.0:
		rect_position = Vector2(60, 28)
		set_process(false)
	else:
		shaking -= delta
		rect_position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))

func screen_shake():
	shaking += .15
	set_process(true)
	screenfx.flash()
	tree.call_group('enemy', 'Clear')

func _next_level():
	if levels.size():
		level.queue_free()
		level = levels.pop_back().instance()
		add_child(level)
		return
		
	elif Engine.editor_hint:
		return
	
	score_data.add_score(hud.point, hud.graze, hud.bomb_count)
	Global.save_resource(stage_name, score_data)
	tree.change_scene_to(next_scene)

func _on_Quit_pressed():
	var tween := screenfx.fade2black()
	tween.connect("finished", tree, 'change_scene', ["res://user-interface/mainMenu/Menu.scn"])

func restart():
	if rewind:
		rewind.rewind()
	else:
		tree.reload_current_scene()
