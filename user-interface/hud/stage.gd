extends Node
class_name Stage

var point := 0
var graze := 0
var goal := 0
var saved := false

export (Array) var levels : Array
export (NodePath) var level
export (String) var stage_name

onready var tree = get_tree()
onready var pause_menu :ColorRect = $Playground/Pause
onready var playground :Control = $Playground
onready var ray :RayCast2D = $Playground/RayCast2D

onready var score_label :Label = $VBoxContainer/Score
onready var graze_label :Label = $VBoxContainer/Graze
onready var point_label :Label = $VBoxContainer/GridContainer/Point
onready var bomb_label :Label = $VBoxContainer/GridContainer/Bomb
onready var goal_label :Label = $VBoxContainer/Goal

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if tree.paused:
			remove_child(pause_menu)
			tree.paused = false
		else:
			add_child(pause_menu)
			tree.paused = true
		
func _physics_process(_delta) -> void:
	if ray.is_colliding():
		ItemManager.target = Global.player

func _ready() -> void:
	Global.connect("collect", self, "_update_point")
	Global.connect('graze', self, '_update_graze')
	Global.connect('bomb', self, '_update_bomb')
	Global.connect('next', self, '_next')
	if Global.save.hi_score.has(stage_name):
		var hi_score :Label = $VBoxContainer/HiScore
		hi_score.text = hi_score.text % Global.save.hi_score[stage_name]
		Global.save.retry_count[stage_name] += 1
	else:
		Global.save.hi_score[stage_name] = 0
		Global.save.retry_count[stage_name] = 1
	
	level = get_node(level)
	remove_child(pause_menu)

func _update_point() -> void:
	point += 1
	point_label.text = point_label.text % point
	_update_score(point * graze)
	
func _update_graze() -> void:
	graze += 1
	graze_label.text = graze_label.text % graze
	_update_score(graze * point)
	
func _update_score(score:int) -> void:
	score_label.text = score_label.text % score
	var score_left = goal - score
	if score_left > 0:
		goal_label.text = goal_label.text % score_left
	else:
		Global.player.bomb += 1
		_update_bomb()

func _update_bomb() -> void:
	bomb_label.text = bomb_label.text %Global.player.bomb
	
func save_score() -> void:
	var score = point * graze
	if Global.save.hi_score[stage_name] < score and not saved:
		Global.save.hi_score[stage_name] = score
		Global.save.save()
		saved = true

func _next() -> void:
	level.queue_free()
	level = levels.pop_back().instance()
	playground.add_child(level)

func _on_Resume_pressed():
	tree.paused = false
	remove_child(pause_menu)

func _on_Continue_pressed():
	pass # Replace with function body.
