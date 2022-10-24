extends Node2D

signal graze
signal collect
signal bomb

signal impact
signal next_level

var save_data : saveData
var player setget _set_player
var boss

const fade_black = Color(0.129412, 0.129412, 0.129412)
const fade_trans = Color(0.129412, 0.129412, 0.129412, 0)
const fade_time = .5

const playground := Vector2(646, 904)
const game_rect := Vector2(1280, 960)

func get_char_data() -> CharacterData:
	return save_data.char_data[player.name]

func _set_player(value:Node2D) -> void:
	player = value
	BulletFx.target = value
	ItemManager.target = value

func _ready() -> void:
	save_data = load('user://save.res')
	var fps = OS.get_screen_refresh_rate()
	if fps:
		Engine.target_fps = fps
		OS.vsync_enabled = false
		
	if not save_data:
		save_data = saveData.new()
	else:
		for key in save_data.key_bind.keys():
			InputMap.action_erase_events(key)
			InputMap.action_add_event(key, save_data.key_bind[key])
	randomize()
