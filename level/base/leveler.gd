extends Node2D
class_name Leveler

var rewind : Rewind
var score : Score

@export var levels :Array[Node]
@export var level :Node
@export_file var next_stage

@onready var tree := get_tree()
@onready var hud :HUD = $Node/hud
@onready var screenfx :ScreenEffect = $Node/hud/ScreenEffect
@onready var user_data :UserData = Global.user_data

func _ready() -> void:
	if user_data.rewind:
		rewind = preload("res://level/base/recorder/Recorder.tscn").instantiate()
		add_child(rewind)
	
	var tween := screenfx.fade2black()
	tween.finished.connect(Callable(screenfx,'set_size').bind(Global.playground))
	
	score = user_data.scores[tree.current_scene.scene_file_path]
	hud.hi_score_label.update_label(score.score)
	
	Global.leveler = self
	add_child(Global.player)

func next_level() -> void:
	if levels.size():
		level.queue_free()
		level = get_node(levels.pop_back())
		level.start_level()
		return
		
	elif Engine.is_editor_hint:
		return
	
	Global.score.save_score()
	Global.user_data.unlock_level(next_stage)
	tree.change_scene_to(next_stage)

func restart() -> void:
	tree.paused = false
	if rewind:
		rewind.rewind()
	else:
		var tween :Tween = screenfx.fade2black()
		tween.finished.connect(Callable(tree,'reload_current_scene'))
