extends Resource
class_name UserSetting

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
export (float) var sentivity := 1.0
export (bool) var raw_input := true setget _set_raw_input
export (Resource) var drag_bind setget _bind_drag
export (Resource) var bomb_bind setget _bind_bomb

##User data
export (Dictionary) var characters := {
	'Reimu' : true,
}

func _bind_drag(event:InputEvent):
	InputMap.action_erase_events('drag')
	InputMap.action_add_event('drag', event)
	
func _bind_bomb(event:InputEvent):
	InputMap.action_erase_events('bomb')
	InputMap.action_add_event('bomb', event)

func _set_raw_input(value:bool):
	Input.use_accumulated_input = value
