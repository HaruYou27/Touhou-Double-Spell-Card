extends Panel
class_name HUD

@onready var user_data := Global.user_data
@export var hi_score_label : FormatLabel
func _ready() -> void:
	if is_instance_valid(Global.player2):
		hi_score_label.template = 'P2-Score: %09d'
	else:
		$VBoxContainer/HBoxContainer/ping.queue_free()
		hi_score_label.update_label(0)
	
	Global.hud = self
	
	score_label.update_label(0)

@export var bomb_label : FormatLabel
func update_bomb(bomb_count) -> void:
	bomb_label.update_label(bomb_count)

var item := 1
func add_item() -> void:
	item += 1
	SoundEffect.hover()
	update_score_request()
	
var graze := 1
func add_graze() -> void:
	graze += 1
	update_score_request()
	
var updating_score := false
## There's no point in updating the score more than 1 per frame.
func update_score_request() -> void:
	if updating_score:
		return
	updating_score = true
	update_score.call_deferred()
	
@export var reward_sfx : AudioStreamPlayer
@export var score_label : FormatLabel
func update_score() -> void:
	var score = graze * item * Engine.time_scale
	score_label.update_label(int(score))
	rpc('_update_p2_score', score)
	updating_score = false

@rpc("any_peer", "unreliable", "call_remote")
func _update_p2_score(value:int) -> void:
	hi_score_label.update_label(value)

var death_count := 0
func player_died() -> void:
	death_count += 1

@onready var pause_menu = $"../PauseMenu"
func save_score() -> void:
	var score := Score.new()
	score.graze = graze
	score.item = item
	score.retry_count = death_count
	
	pause_menu.display_score(score)
