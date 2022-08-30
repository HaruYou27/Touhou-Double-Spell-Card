extends Node
class_name Stage

var score := 0
var point := 0
var graze := 0
var goal := 0

export (Array) var spellcards : Array
export (NodePath) var current_spell
export (String) var stage_name

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
	Global.connect('bomb', self, '_update_bomb')
	Global.connect('collect_bullet', self, '_update_score', Global.bullet_value)
	if Global.save.hi_score.has(stage_name):
		hi_score.text = hi_score.text % Global.save.hi_score[stage_name]
	else:
		Global.save.hi_score[stage_name] = 0
	
	current_spell = get_node(current_spell)

func _update_point() -> void:
	point += 1
	point_label.text = point_label.text % point
	_update_score(Global.point_value)
	
func _update_graze() -> void:
	graze += 1
	graze_label.text = graze_label.text % graze
	_update_score(Global.graze_value)
	
func _update_score(value:int) -> void:
	score += value
	score_label.text = score_label.text %score
	var score_left = goal - score
	if score_left > 0:
		goal_label.text = goal_label.text %(goal - score)
	else:
		Global.player.bomb += 1
		_update_bomb()
	
func _update_bomb() -> void:
	bomb_label.text = bomb_label.text %Global.player.bomb
	
func _exit_tree() -> void:
	if Global.save.hi_score[stage_name] < Global.score:
		Global.save.hi_score[stage_name] = Global.score
		Global.save.save()

func next() -> void:
	current_spell.queue_free()
	current_spell = spellcards.pop_back().instance()
	playground.add_child(current_spell)
