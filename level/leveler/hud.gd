extends ColorRect
class_name HUD

@onready var user_data := Global.user_data
@export var hi_score_label : FormatLabel
func _ready() -> void:
	if is_instance_valid(Global.player2):
		if is_multiplayer_authority():
			hi_score_label.template = 'P2-Score: %09d'
		else:
			hi_score_label.template = 'P1-Score: %09d'
	else:
		$VBoxContainer/HBoxContainer/ping.queue_free()
		hi_score_label.update_label(0)
	
	Global.item_collect.connect(_add_item)
	Global.bullet_graze.connect(_add_graze)
	Global.hud = self
	
	score_label.update_label(0)
	bomb_label.update_label(1)

@export var bomb_label : FormatLabel
func update_bomb() -> void:
	bomb_label.update_label(Global.player.bomb_count)

#There's no point in updating the score more than 1 per frame.
var item := 0
func _add_item() -> void:
	item += 1
	SoundEffect.hover()
	update_score()
	
var graze := 0
func _add_graze() -> void:
	graze += 1
	update_score()
	
var updating_score := false	
func update_score() -> void:
	if updating_score:
		return
	updating_score = true
	call_deferred('_update_score')
	
@export var reward_sfx : AudioStreamPlayer
@export var score_label : FormatLabel
func _update_score() -> void:
	var score = graze * item * Engine.time_scale
	score_label.update_label(int(score))
	rpc('_update_p2_score', score)

@rpc("any_peer")
func _update_p2_score(value:int) -> void:
	hi_score_label.update_label(value)

func player_died() -> void:
	item /= 2
	graze /= 2
