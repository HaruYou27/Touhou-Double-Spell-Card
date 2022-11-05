extends Resource
class_name saveData

### Game settings data
#Gameplay
export (bool) var assist_mode := false
export (float) var death_time := .3
export (float) var bomb_damage := .5
export (int) var init_bomb := 3

#Graphic
export (bool) var fullscreen := false setget _set_fullscreen
export (bool) var borderless := false setget _set_borderless
export (bool) var show_fps := false
export (bool) var rewind := false

#Audio
export (float) var master_db := 0.0 setget _set_master_db
export (float) var bgm_db := 0.0 setget _set_bgm_db
export (float) var sfx_db := 0.0 setget _set_sfx_db

#Controls
export (bool) var auto_shoot := true
export (bool) var use_mouse := false

export (Dictionary) var key_bind := {
	'ui_left' : KEY_LEFT,
	'ui_right' : KEY_RIGHT,
	'ui_up' : KEY_UP,
	'ui_down' : KEY_DOWN,
	'focus' : KEY_SHIFT,
	'shoot' : KEY_Z,
	'bomb' : KEY_X
}

### User data
export (Dictionary) var char_data := {
	'reimu' : CharacterData.new()
}
export (String) var last_level

onready var release := not OS.is_debug_build()

func _set_sfx_db(value:float) -> void:
	sfx_db = value
	AudioServer.set_bus_volume_db(2, value)

func _set_bgm_db(value:float) -> void:
	bgm_db = value
	AudioServer.set_bus_volume_db(1, value)

func _set_master_db(value:float) -> void:
	master_db = value
	AudioServer.set_bus_volume_db(0, value)

func _set_borderless(value:bool) -> void:
	borderless = value
	OS.window_borderless = value
	
func _set_fullscreen(value:bool) -> void:
	fullscreen = value
	OS.window_fullscreen = value

func save() -> void:
	if release:
		ResourceSaver.save('user://save.res', self)
