extends ColorRect
class_name HUD

var score := 0.
var item := 0
var goal := 0

@onready var user_data := Global.user_data

@export var fps_label : FormatLabel
@onready var peer2 : ENetPacketPeer = multiplayer.multiplayer_peer.get_peer(2)
func _process(_delta):
	fps_label.update_label(Performance.get_monitor(Performance.TIME_FPS))
	ping_label.update_label(peer2.get_statistic(ENetPacketPeer.PEER_ROUND_TRIP_TIME))

@export var hi_score_label : FormatLabel
@export var ping_label : FormatLabel
func _ready() -> void:
	if multiplayer.has_multiplayer_peer():
		if is_multiplayer_authority():
			hi_score_label.template = 'P2-Score: %018d'
		else:
			hi_score_label.template = 'P1-Score: %018d'
			
		hi_score_label.update_label(0)
	else:
		ping_label.queue_free()
		hi_score_label.update_label(user_data.scores.get(user_data.last_level, 0))
	
	Global.item_collect.connect(_add_item)
	Global.bullet_graze.connect(_add_graze)
	Global.hud = self
	Global.bomb_finished.connect(_update_bomb)
	
	score_label.update_label(0)
	goal_label.update_label(0)
	bomb_label.update_label(1)

@export var bomb_label :FormatLabel
func _update_bomb() -> void:
	bomb_label.update_label(Global.player.bomb_count)

#There's no point in updating the score more than 1 per frame.
@export var pickup_sfx : AudioStreamPlayer
func _add_item() -> void:
	item += 1
	pickup_sfx.play()
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
@export var score_label :FormatLabel
@export var goal_label :FormatLabel
func _update_score() -> void:
	score = pow(graze * item, Engine.time_scale)
	score_label.update_label(int(score))
	rpc('_update_p2_score', score)
	
	var score_left = goal - score
	if score_left < INF:
		goal_label.update_label(score_left)
	else:
		Global.player.bomb_count += 1
		reward_sfx.play()
		_update_bomb()

@rpc("any_peer")
func _update_p2_score(value:int) -> void:
	hi_score_label.update_label(value)
