extends Resource
class_name Config

##Config
#Gameplay
export (bool) var death_assist := true
export (bool) var cheat := false
export (float) var game_speed := 1.0
export (float) var assit_duration := .3
export (bool) var infinity_bomb := false
export (bool) var invicible := false

#Graphic
export (bool) var rewind := false
export (bool) var full_particle := true
export (bool) var dynamic_background := true

#Controls
export (bool) var auto_shoot := true
export (bool) var use_mouse := false
export (bool) var use_joystick := false

##User data
export (Dictionary) var characters := {
	'Reimu' : true,
}
export (String) var last_level
export (bool) var first_time := true
export (bool) var first_character := true
