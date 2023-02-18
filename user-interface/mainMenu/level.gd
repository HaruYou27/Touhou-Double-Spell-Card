extends Control

onready var list :VBoxContainer = $HBoxContainer2/list
onready var preview :TextureRect = $HBoxContainer2/preview
onready var score :FormatLabel = $HBoxContainer2/score/HiScore
onready var graze :FormatLabel = $HBoxContainer2/score/Graze
onready var item :FormatLabel = $HBoxContainer2/score/item
onready var speed :FormatLabel = $HBoxContainer2/score/speed
onready var death_duration :FormatLabel = $HBoxContainer2/score/duration

var levels := []
var header :LevelHeader

func _ready():
	var i := 0
	for level in Global.user_data.unlocked_levels:
		var header :LevelHeader = load(level)
		header.load_score()
		levels.append(header)
		var button := UberButton.new()
		button.text = header.title
		button.connect("pressed", self, '_select_level', [i])
		
		list.add_child(button)
		i += 1
		
func _select_level(index):
	header = levels[index]
	preview.texture = header.preview
	
	var score_data = header.score
	score.update_label(score_data.score)
	graze.update_label(score_data.graze)
	item.update_label(score_data.item)
	death_duration.update_label(score_data.death_timer)
	speed.update_label(score_data.game_speed)

func load_level():
	if not header:
		return
		
	Engine.time_scale = $HBoxContainer2/score/SpeedSlider.value
	Global.death_timer = $HBoxContainer2/score/DurationSlider.value
	get_tree().change_scene_to(header.level)
