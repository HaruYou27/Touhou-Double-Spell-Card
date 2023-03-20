extends ColorRect
class_name HUD

var score := 0
var item := 0.0
var updating_item := false
var graze := 0
var updating_graze := false
var goal := 0

@onready var hi_score_label :FormatLabel = $VBoxContainer/HiScore
@onready var score_label :FormatLabel = $VBoxContainer/Score
@onready var graze_label :FormatLabel = $VBoxContainer/Graze
@onready var item_label :FormatLabel = $VBoxContainer/item
@onready var pickup_sfx : AudioStreamPlayer = $pickup
@onready var bomb_label :FormatLabel = $VBoxContainer/Bomb
@onready var reward_sfx : AudioStreamPlayer = $reward
@onready var goal_label :FormatLabel = $VBoxContainer/Goal

@onready var multiplier := pow(Global.score.death_time, Engine.time_scale)

func _ready() -> void:
	Global.connect("item_collect",Callable(self,"_set_item"))
	Global.connect('bullet_graze',Callable(self,'_set_graze'))
	
	score_label.update_label(0)
	item_label.update_label(0)
	goal_label.update_label(0)
	bomb_label.update_label(1)

#There's no item in updating the score more than 1 per frame.
func _set_item(value:float) -> void:
	item += value
	if updating_item:
		return
	
	updating_item = true
	call_deferred('_update_item')
	
func _update_item() -> void:
	updating_item = false
	item_label.update_label(item)

	if updating_graze:
		return
	_update_score()

func _set_graze() -> void:
	graze += 10
	if updating_graze:
		return
		
	updating_graze = true
	call_deferred('_update_graze')

func _update_graze() -> void:
	updating_graze = false
	graze_label.update_label(graze)

	if updating_item:
		return
	_update_score()
	
func _update_score() -> void:
	score = int(sqrt(graze * item) / multiplier)
	score_label.update_label(score)
	
	var score_left = goal - score
	if score_left < INF:
		goal_label.update_label(score_left)
	else:
		Global.player.bomb_count += 1
		reward_sfx.play()
		_update_bomb()

func _update_bomb() -> void:
	bomb_label.update_label(Global.player.bomb_count)
