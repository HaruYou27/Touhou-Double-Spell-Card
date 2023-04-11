extends ColorRect
class_name HUD

var score := 0.
var item := 0
var graze := 0
var goal := 0
var updating_score := false

@onready var multiplier := Engine.time_scale / Global.user_data.death_time

@onready var score_file :Score = Global.score
@onready var hi_score_label :FormatLabel = $VBoxContainer/HiScore
@onready var score_label :FormatLabel = $VBoxContainer/Score
@onready var goal_label :FormatLabel = $VBoxContainer/Goal
@onready var bomb_label :FormatLabel = $VBoxContainer/HBoxContainer/Bomb

@onready var pickup_sfx : AudioStreamPlayer = $pickup
@onready var reward_sfx : AudioStreamPlayer = $reward

func _ready() -> void:
	hi_score_label.update_label(score_file.score)
	score_file.attempt += 1
	
	Global.item_collect.connect(_add_item)
	Global.bullet_graze.connect(_add_graze)
	Global.hud = self
	Global.bomb_finished.connect(_update_bomb)
	
	score_label.update_label(0)
	goal_label.update_label(0)
	bomb_label.update_label(1)

#There's no point in updating the score more than 1 per frame.
func _add_item() -> void:
	item += 1
	pickup_sfx.play()
	update_score()
	
func _add_graze() -> void:
	graze += 1
	update_score()

func update_score() -> void:
	if updating_score:
		return
	updating_score = true
	call_deferred('_update_score')

func _update_score() -> void:
	score = sqrt(graze * item) * multiplier
	score_label.update_label(int(score))
	
	var score_left = goal - score
	if score_left < INF:
		goal_label.update_label(score_left)
	else:
		Global.player.bomb_count += 1
		reward_sfx.play()
		_update_bomb()

func _update_bomb() -> void:
	bomb_label.update_label(Global.player.bomb_count)
