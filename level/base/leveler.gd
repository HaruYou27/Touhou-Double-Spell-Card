extends Control
class_name Leveler

var shaking := 0.0
var rewind

export (Array) var levels : Array
export (NodePath) var level
export (PackedScene) var next_scene

onready var tree = get_tree()
onready var hud :Sprite = $Node/hud
onready var screenfx :ScreenEffect = $Node/hud/ScreenEffect
onready var item_manager := $ItemManager
onready var config :UserData = Global.user_data

func _ready():
	Global.connect("bomb_impact", self, 'screen_shake')
	
	if config.rewind:
		rewind = preload("res://level/base/recorder/Recorder.tscn").instance()
		add_child(rewind)
	
	var tween := screenfx.fade2black()
	tween.connect("finished", screenfx, 'set_size', [rect_size])
	
	Global.score.retry += 1
	level = get_node(level)
	level.start()
	Global.leveler = self
	next_scene = next_scene.resource_path
	
func _process(delta):
	if shaking <= 0.0:
		rect_position = Vector2(526, 88)
		set_process(false)
	else:
		shaking -= delta
		rect_position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))

func screen_shake():
	shaking += .15
	set_process(true)
	screenfx.flash()
	tree.call_group('enemy', 'Clear')

func next_level():
	if levels.size():
		level.queue_free()
		level = get_node(levels.pop_back())
		level.start()
		return
		
	elif Engine.editor_hint:
		return
	
	Global.score.save_score()
	Global.user_data.unlocked_levels.append(next_scene)

func _on_Quit_pressed():
	var tween := screenfx.fade2black()
	tween.connect("finished", tree, 'change_scene', ["res://user-interface/mainMenu/Menu.scn"])

func restart():
	if rewind:
		rewind.rewind()
	else:
		tree.reload_current_scene()
