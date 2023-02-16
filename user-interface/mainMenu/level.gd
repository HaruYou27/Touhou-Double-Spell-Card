extends Control

onready var list :VBoxContainer = $HBoxContainer2/list
onready var preview :TextureRect = $HBoxContainer2/preview
onready var score :FormatLabel = $HBoxContainer2/score/HiScore
onready var graze :FormatLabel = $HBoxContainer2/score/Graze
onready var item :FormatLabel = $HBoxContainer2/score/Point
onready var speed :FormatLabel = $HBoxContainer2/score/speed
onready var death_duration :FormatLabel = $HBoxContainer2/score/duration

export (Reso)var levels := []

func _ready():
	var i := 0
	for level in Global.user_data.unlocked_levels:
		var header :LevelHeader = load(level)
		levels.append(header)
		var button := UberButton.new()
		button.text = header.title
		button.connect("pressed", self, '_select_level', [i])
		
		list.add_child(button)
		i += 1
		
func _select_level(index):
	var header :LevelHeader = levels[index]
	preview.texture = header.texture
	
	var score_data = header.score
	score.update_label(score_data.score)
	graze.update_label(score_data.graze)
	item.update_label(score_data.item)
	death_duration.update_label(score_data.death_duration)
	speed.update_label(score_data.game_speed)
