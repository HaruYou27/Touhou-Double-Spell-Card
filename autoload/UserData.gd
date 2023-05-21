extends Resource
class_name UserData

@export_category('Gameplay')
@export var game_speed := 1.

@export_category('Audio')
@export var push2talk := true
@export var voice_volume := 0.

@export_category('Graphic')
@export var full_particle := true
@export var dynamic_background := true

@export_category("Controls")
@export var sentivity := 1.2
@export var raw_input := true : set = _set_raw_input
func _set_raw_input(value:bool) -> void:
	Input.use_accumulated_input = value
	
@export var drag_bind := InputMap.action_get_events('drag')[0] : set = _bind_drag
func _bind_drag(event:InputEvent) -> void:
	InputMap.action_erase_events('drag')
	InputMap.action_add_event('drag', event)
	drag_bind = event
	
@export var bomb_button := false
@export var bomb_bind := InputMap.action_get_events('bomb')[0] : set = _bind_bomb
func _bind_bomb(event:InputEvent) -> void:
	InputMap.action_erase_events('bomb')
	InputMap.action_add_event('bomb', event)
	bomb_bind = event
	
@export var voice_bind := InputMap.action_get_events('voice')[0] : set = _bind_voice
func _bind_voice(event:InputEvent) -> void:
	InputMap.action_erase_events('voice')
	InputMap.action_add_event('voice', event)
	voice_bind = event

@export_category('User data')
@export var death_time := .3
@export var shoot_type := "res://entity/Reimu/HomingShoot.tscn"

@export var scores := {}
@export var last_level : String
