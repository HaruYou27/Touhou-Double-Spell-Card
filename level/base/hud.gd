extends Sprite

var point := 0
var updating_point := false
var graze := 0
var updating_graze := false
var goal := 0

onready var score_label :FormatLabel = $VBoxContainer/Score
onready var graze_label :FormatLabel = $VBoxContainer/Graze
onready var point_label :FormatLabel = $VBoxContainer/Point
onready var pickup_sfx : AudioStreamPlayer = $pickup
onready var bomb_label :FormatLabel = $VBoxContainer/Bomb
onready var reward_sfx :AudioStreamPlayer = $reward
onready var goal_label :FormatLabel = $VBoxContainer/Goal

func _ready():
	Global.connect("collect", self, "_set_point")
	Global.connect('graze', self, '_set_graze')
	
	score_label.update_label(0)
	point_label.update_label(0)
	goal_label.update_label(0)

func _set_point(value):
	point += value
	if updating_point:
		return
	
	updating_point = true
	call_deferred('_update_point')
	
func _update_point():
	updating_point = false
	point_label.update_label(point)

	if updating_graze:
		return
	_update_score()

func _set_graze():
	graze += 1
	if updating_graze:
		return
		
	updating_graze = true
	call_deferred('_update_graze')

func _update_graze():
	updating_graze = false
	graze_label.update_label(graze)

	if updating_point:
		return
	_update_score()
	
func _update_score():
	var score := graze * point
	score_label.update_label(score)
	var score_left = goal - score
	if score_left < INF:
		goal_label.update_label(score_left)
	else:
		Global.player.bombs += 1
		_update_bomb()

func _update_bomb():
	bomb_label.update_label(Global.player.bomb_count)
