extends Control

@onready var list :BoxContainer = $VBoxContainer/ScrollContainer/LevelList
@onready var preview :TextureRect = $HBoxContainer2/preview
@onready var score :FormatLabel = $HBoxContainer2/score/HiScore
@onready var graze :FormatLabel = $HBoxContainer2/score/Graze
@onready var item :FormatLabel = $HBoxContainer2/score/item
@onready var game_speed :Slider = $HBoxContainer2/score/SpeedSlider
@onready var death_duration :Slider = $HBoxContainer2/score/DurationSlider
@onready var shoot_type :OptionButton = $HBoxContainer2/score/ShootType

@export var players : Array[PackedScene]
@export var levels : Array[LevelHeader]
var header : LevelHeader

func _ready() -> void:
	var i := 0
	for level in levels:
		var button := UberButton.new()
		button.text = level.title
		button.pressed.connect(Callable(self,'_select_level').bind(i))
		button.disabled = level.load_score()
		
		list.add_child(button)
		i += 1
		
func _select_level(index:int) -> void:
	header = levels[index]
	preview.texture = header.preview
	
	var score_data = header.score
	score.update_label(score_data.score)
	graze.update_label(score_data.graze)
	item.update_label(score_data.item)
	death_duration.value = score_data.death_time
	game_speed.value = score_data.game_game_speed
	shoot_type.selected = score_data.shoot_type

func load_level() -> void:
	if not header:
		return
		
	Global.player = players[shoot_type.selected].instantiate()
	header.score.save_setting(shoot_type.selected, $HBoxContainer2/score/DurationSlider.value)
	Engine.time_scale = $HBoxContainer2/score/game_speedSlider.value
	get_tree().change_scene_to_file(header.level)
