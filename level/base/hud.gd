extends Sprite

var point := 0
var graze := 0
var goal := 0

onready var score_label :FormatLabel = $VBoxContainer/Score
onready var graze_label :FormatLabel = $VBoxContainer/Graze
onready var point_label :FormatLabel = $VBoxContainer/Point
onready var bomb_label :FormatLabel = $VBoxContainer/Bomb
onready var goal_label :FormatLabel = $VBoxContainer/Goal

func _ready():
	Global.connect("collect", self, "_update_point")
	Global.connect('graze', self, '_update_graze')
	Global.connect('bomb', self, '_update_bomb')
	
	bomb_label.update_label(Global.config.init_bomb)
	score_label.update_label(0)
	point_label.update_label(0)
	goal_label.update_label(0)

func _update_point(value = 1):
	point += value
	point_label.update_label(point)
	_update_score(point * graze)
	
func _update_graze():
	graze += 1
	graze_label.update_label(graze)
	_update_score(graze * point)
	
func _update_score(score:int):
	score_label.update_label(score)
	var score_left = goal - score
	if score_left < INF:
		goal_label.update_label(score_left)
	else:
		Global.player.bombs += 1
		_update_bomb()

func _update_bomb():
	bomb_label.update_label(Global.player.bombs)
