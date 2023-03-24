extends Node2D
class_name Leveler
##Node that controls the current_event.

var rewind : Rewind

##Next level scene path.
@export_file var next_level

@onready var tree := get_tree()
@onready var hud := $hud
@onready var screenfx :ScreenEffect = $hud/ScreenEffect
@onready var user_data :UserData = Global.user_data

func _ready() -> void:
	if user_data.rewind:
		rewind = preload("res://level/base/recorder/Recorder.tscn").instantiate()
		add_child(rewind)
	
	var tween := screenfx.fade2black()
	tween.finished.connect(Callable(screenfx,'set_size').bind(global.playground))
	
	var score = load(user_data.scores[tree.current_scene.scene_file_path])
	add_child(score.player.instantiate())
	hud.score_file = score
	
	Global.leveler = self

##Level finisher.
func finished() -> void:
	if Engine.is_editor_hint:
		return
	
	hud.save_score()
	Global.user_data.unlock_level(next_level)
	tree.change_scene_to(next_level)

##Restart the level.
func restart() -> void:
	tree.paused = false
	if rewind:
		rewind.rewind()
	else:
		var tween :Tween = screenfx.fade2black()
		tween.finished.connect(Callable(tree,'reload_current_scene'))
