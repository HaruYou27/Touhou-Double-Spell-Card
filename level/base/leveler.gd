extends Node2D
class_name Leveler

var rewind

@export var levels :Array[Node]
@export var level :Node
@export_file var next_stage

@onready var tree = get_tree()
@onready var hud :Sprite2D = $Node/hud
@onready var screenfx :ScreenEffect = $Node/hud/ScreenEffect
@onready var item_manager := $ItemManager
@onready var config :UserData = Global.user_data

func _ready() -> void:
	Global.connect("bomb_impact",Callable(self,'screen_shake'))
	
	if config.rewind:
		rewind = preload("res://level/base/recorder/Recorder.tscn").instantiate()
		add_child(rewind)
	
	var tween := screenfx.fade2black()
	tween.connect("finished",Callable(screenfx,'set_size').bind(Global.playground))
	
	if Global.score:
		Global.score.retry += 1
	Global.leveler = self
	add_child(Global.player)

func next_level() -> void:
	if levels.size():
		level.queue_free()
		level = get_node(levels.pop_back())
		level.start()
		return
		
	elif Engine.is_editor_hint:
		return
	
	Global.score.save_score()
	Global.user_data.unlocked_levels.append(next_stage)
	#tree.change_scene_to_packed(next_scene.level)

func _on_Quit_pressed() -> void:
	tree.paused = false
	var tween := screenfx.fade2black()
	tween.connect("finished",Callable(tree,'change_scene_to_file').bind("res://user-interface/mainMenu/Menu.tscn"))

func restart() -> void:
	tree.paused = false
	if rewind:
		rewind.rewind()
	else:
		var tween := screenfx.fade2black()
		tween.connect("finished",Callable(tree,'reload_current_scene'))
