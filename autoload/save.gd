extends Resource
class_name saveData

### Game settings data
#Gameplay
export (bool) var death_assit := true
export (bool) var assist_mode := false
export (float) var game_speed := 1.0
export (float) var assit_duration := .3
export (int) var init_bomb := 3
export (bool) var invicible := false

#Graphic
export (bool) var rewind := false

#Controls
export (bool) var auto_shoot := false
export (bool) var use_mouse := false

### User data
export (Dictionary) var char_data := {
	'reimu' : CharacterData.new()
}
export (String) var last_level
