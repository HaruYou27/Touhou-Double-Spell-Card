extends Panel

@onready var user_data := Global.user_data
@export var hi_score_label : FormatLabel
func _ready() -> void:
	hi_score_label.update_label(0)
	
	score_label.update_label(0)
	GlobalScore.bomb_changed.connect(_update_bomb)
	GlobalScore.score_changed.connect(_update_score)
	_update_bomb(GlobalScore.get_bomb())

@export var bomb_label : FormatLabel
func _update_bomb(bomb_count:int) -> void:
	bomb_label.update_label(bomb_count)
	
@export var reward_sfx : AudioStreamPlayer
@export var score_label : FormatLabel
func _update_score(score:int) -> void:
	score_label.update_label(score)

@onready var pause_menu = $"../PauseMenu"
func save_score(_nm) -> void:
	var score := Score.new()
	score.graze = GlobalScore.get_graze()
	score.item = GlobalScore.get_item()
	score.retry_count =  GlobalScore.get_death_count()
	
	pause_menu.display_score(score)
