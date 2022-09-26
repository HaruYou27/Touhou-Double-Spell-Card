extends Sprite

var point := 1
var graze := 0
var goal := 0

onready var score_label :Label = $VBoxContainer/Score
onready var graze_label :Label = $VBoxContainer/Graze
onready var point_label :Label = $VBoxContainer/Point
onready var bomb_label :Label = $VBoxContainer/Bomb
onready var goal_label :Label = $VBoxContainer/Goal

func _ready() -> void:
	Global.connect("collect", self, "_update_point")
	Global.connect('graze', self, '_update_graze')
	Global.connect('bomb', self, '_update_bomb')
	
	bomb_label.text = bomb_label.text % Global.player.bombs

func _update_point(value = 1) -> void:
	point += value
	point_label.text = 'Point:                         %09d' % point
	_update_score(point * graze)
	
func _update_graze() -> void:
	graze += 1
	graze_label.text = 'Graze:                       %09d' % graze
	_update_score(graze * point)
	
func _update_score(score:int) -> void:
	score_label.text = 'Score:           %010d' % score
	var score_left = goal - score
	if score_left < INF:
		goal_label.text = 'Next:                      %010d' % score_left
	else:
		Global.player.bomb += 1
		_update_bomb()

func _update_bomb() -> void:
	bomb_label.text = 'Bomb:        %d' % Global.player.bombs
