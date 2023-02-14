extends Sprite
class_name HUD

var score := 0
var item := 0
var updating_item := false
var graze := 0
var updating_graze := false
var goal := 0

onready var score_label :FormatLabel = $VBoxContainer/Score
onready var graze_label :FormatLabel = $VBoxContainer/Graze
onready var item_label :FormatLabel = $VBoxContainer/item
onready var pickup_sfx : AudioStreamPlayer = $pickup
onready var bomb_label :FormatLabel = $VBoxContainer/Bomb
onready var reward_sfx :AudioStreamPlayer = $reward
onready var goal_label :FormatLabel = $VBoxContainer/Goal

onready var user_setting :UserSetting = Global.user_setting

func _ready():
	Global.connect("item_collect", self, "_set_item")
	Global.connect('bullet_graze', self, '_set_graze')
	
	score_label.update_label(0)
	item_label.update_label(0)
	goal_label.update_label(0)
	bomb_label.update_label(1)

#There's no item in updating the score more than 1 per frame.
func _set_item(value):
	item += value
	if updating_item:
		return
	
	updating_item = true
	call_deferred('_update_item')
	
func _update_item():
	updating_item = false
	item_label.update_label(item)

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

	if updating_item:
		return
	_update_score()
	
func _update_score():
	score = (500*Global.player.bomb_bount + graze) * item * user_setting.game_speed / user_setting.death_duration
	score_label.update_label(score)
	var score_left = goal - score
	if score_left < INF:
		goal_label.update_label(score_left)
	else:
		Global.player.bomb_count += 1
		Global.emit_signal("player_reward")
		bomb_label.update_label(Global.player.bomb_count)

func _update_bomb():
	bomb_label.update_label(Global.player.bomb_count)
