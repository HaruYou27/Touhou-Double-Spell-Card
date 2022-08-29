extends Node
class_name Stage

signal _update_bomb()

var score := 0
var point := 0
var graze := 0
var goal := 0

export (Array) var spellcards : Array
export (NodePath) var current_spell
export (String) var stage_name

onready var point_value := Global.save.point_value
onready var graze_value := Global.save.graze_value
onready var playground :Control = $Playground
onready var hi_score :Label = $VBoxContainer/HiScore
onready var score_label :Label = $VBoxContainer/Score
onready var graze_label :Label = $VBoxContainer/Graze
onready var point_label :Label = $VBoxContainer/GridContainer/Point
onready var bomb_label :Label = $VBoxContainer/GridContainer/Bomb
onready var goal_label :Label = $VBoxContainer/Goal

func _ready() -> void:
	Global.connect("collect", self, "_update_point")
	Global.connect('graze', self, '_update_graze')
	if Global.save.hi_score.has(stage_name):
		hi_score.text = hi_score.text % Global.save.hi_score[stage_name]
	else:
		Global.save.hi_score[stage_name] = 0
	
	current_spell = get_node(current_spell)

func _update_point() -> void:
	point += 1
	point_label.text = point_label.text % point
	_update_score(point_value)
	
func _update_graze() -> void:
	graze += 1
	graze_label.text = graze_label.text % graze
	_update_score(graze_value)
	
func _update_score(value:int) -> void:
	score += value
	score_label.text = score_label.text %score
	goal_label.text = goal_label.text %(goal - score)
	
func _update_bomb(value:int) -> void:
	bomb_label.text = bomb_label.text %value
	
func _exit_tree() -> void:
	if Global.save.hi_score[stage_name] < Global.score:
		Global.save.hi_score[stage_name] = Global.score
		Global.save.save()

func next() -> void:
	current_spell.queue_free()
	current_spell = spellcards.pop_back().instance()
	playground.add_child(current_spell)
