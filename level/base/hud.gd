extends ColorRect

var score := 0
var item := 0.0
var updating_item := false
var graze := 0
var updating_graze := false
var goal := 0

var multiplier := 0.

@onready var score_file :Score = Global.score
@onready var hi_score_label :FormatLabel = $VBoxContainer/HiScore
@onready var score_label :FormatLabel = $VBoxContainer/Score
@onready var graze_label :FormatLabel = $VBoxContainer/Graze
@onready var item_label :FormatLabel = $VBoxContainer/item
@onready var pickup_sfx : AudioStreamPlayer = $pickup
@onready var bomb_label :FormatLabel = $VBoxContainer/Bomb
@onready var reward_sfx : AudioStreamPlayer = $reward
@onready var goal_label :FormatLabel = $VBoxContainer/Goal

func save_score() -> void:
	if score_file.score > score:
		score_file.score = score
		score_file.graze = graze
		score_file.item = item
	
	ResourceSaver.save(score_file, score_file.resource_path, ResourceSaver.FLAG_COMPRESS)

func _ready() -> void:
	hi_score_label.update_label(score_file.score)
	multiplier = pow(Global.score.death_time, Engine.time_scale)
	
	Global.connect("item_collect",Callable(self,"_set_item"))
	Global.connect('bullet_graze',Callable(self,'_set_graze'))
	
	score_label.update_label(0)
	item_label.update_label(0)
	goal_label.update_label(0)
	bomb_label.update_label(1)
	graze_label.update_label(0)

#There's no point in updating the score more than 1 per frame.
func _set_item(value:=1.) -> void:
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
