extends Control

@onready var list :BoxContainer = $VBoxContainer/ScrollContainer/LevelList
@onready var preview :TextureRect = $TabContainer/preview
@onready var score :FormatLabel = $TabContainer/TabContainer/LevelInfo/HiScore
@onready var graze :FormatLabel = $TabContainer/TabContainer/LevelInfo/Graze
@onready var item :FormatLabel = $TabContainer/TabContainer/LevelInfo/item
@onready var game_speed :Slider = $TabContainer/TabContainer/LevelInfo/SpeedSlider
@onready var death_duration :Slider = $TabContainer/TabContainer/LevelInfo/duration
@onready var shoot_type :OptionButton = $TabContainer/TabContainer/LevelInfo/ShootType
@onready var container : TabContainer = $TabContainer

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
	header.score.save_setting(shoot_type.selected, $TabContainer/TabContainer/LevelInfo/DurationSlider.value)
	Engine.time_scale = $TabContainer/TabContainer/LevelInfo/game_speedSlider.value
	get_tree().change_scene_to_file(header.level)

func _on_info_toggler_toggled(button_pressed:bool) -> void:
	container.current_tab = int(button_pressed)
