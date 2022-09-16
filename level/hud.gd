extends Sprite

var point := 1
var graze := 0
var goal := 0

onready var score_label :Label = $VBoxContainer/Score
onready var graze_label :Label = $VBoxContainer/Graze
onready var point_label :Label = $VBoxContainer/Point
onready var bomb_label :Label = $VBoxContainer/Bomb
onready var goal_label :Label = $VBoxContainer/Goal

onready var stage_name :String = get_parent().stage_name

func _ready() -> void:
	Global.connect("collect", self, "_update_point")
	Global.connect('graze', self, '_update_graze')
	Global.connect('bomb', self, '_update_bomb')
	
	if Global.save_data.hi_score.has(stage_name):
		var hi_score :Label = $VBoxContainer/HiScore
		hi_score.text = hi_score.text % Global.save_data.hi_score[stage_name]
		Global.save_data.try_count[stage_name] += 1
	else:
		Global.save_data.hi_score[stage_name] = 0
		Global.save_data.try_count[stage_name] = 1
	
	bomb_label.text = bomb_label.text % Global.save_data.init_bomb

func _update_point() -> void:
	point += 1
	point_label.text = 'Point:                         %06d' % point
	_update_score(point * graze)
	
func _update_graze() -> void:
	graze += 1
	graze_label.text = 'Graze:                       %06d' % graze
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

func save_score() -> void:
	if Global.save_data.assist_mode:
		return
		
	var score = point * graze
	if Global.save_data.hi_score[stage_name] < score:
		Global.save_data.hi_score[stage_name] = score
		Global.save_data.save_data()
