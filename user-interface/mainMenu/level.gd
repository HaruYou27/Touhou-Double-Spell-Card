extends Control

@onready var list :VBoxContainer = $HBoxContainer2/list
@onready var preview :TextureRect = $HBoxContainer2/preview
@onready var score :FormatLabel = $HBoxContainer2/score/HiScore
@onready var graze :FormatLabel = $HBoxContainer2/score/Graze
@onready var item :FormatLabel = $HBoxContainer2/score/item
@onready var speed :FormatLabel = $HBoxContainer2/score/speed
@onready var death_duration :FormatLabel = $HBoxContainer2/score/duration
@onready var shoot_type :OptionButton = $HBoxContainer2/score/ShootType

var levels := []
var header :LevelHeader

@export (Array) var players

func _ready():
	var i := 0
	for level in Global.user_data.unlocked_levels:
		var header :LevelHeader = load(level)
		header.load_score()
		levels.append(header)
		var button := UberButton.new()
		button.text = header.title
		button.connect("pressed",Callable(self,'_select_level').bind(i))
		
		list.add_child(button)
		i += 1
		
func _select_level(index):
	header = levels[index]
	preview.texture = header.preview
	
	var score_data = header.score
	score.update_label(score_data.score)
	graze.update_label(score_data.graze)
	item.update_label(score_data.item)
	death_duration.update_label(score_data.death_time)
	speed.update_label(score_data.game_speed)
	shoot_type.selected = score_data.shoot_type

func load_level():
	if not header:
		return
		
	Global.score = header.score
	Global.player = players[shoot_type.selected].instantiate()
	header.score.save_setting(shoot_type.selected, $HBoxContainer2/score/DurationSlider.value)
	Engine.time_scale = $HBoxContainer2/score/SpeedSlider.value
	get_tree().change_scene_to_packed(header.level)
