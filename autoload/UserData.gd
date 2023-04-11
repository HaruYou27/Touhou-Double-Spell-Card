extends Resource
class_name UserData

@export_category('Graphic')
@export var full_particle := true
@export var dynamic_background := true

@export_category("Controls")
@export var sentivity := 1.2
@export var raw_input := true : set = _set_raw_input
@export var drag_bind : InputEvent : set = _bind_drag
@export var bomb_bind : InputEvent : set = _bind_bomb

@export_category('User data')
@export var death_time := .3
@export var game_speed := 1.
@export_file var shoot_type := "res://entity/Reimu/HomingShoot.tscn"

@export var scores := {}
@export var last_level := 0

func _bind_drag(event:InputEvent) -> void:
	InputMap.action_erase_events('drag')
	InputMap.action_add_event('drag', event)
	drag_bind = event
	
func _bind_bomb(event:InputEvent) -> void:
	InputMap.action_erase_events('bomb')
	InputMap.action_add_event('bomb', event)
	bomb_bind = event

func _set_raw_input(value:bool) -> void:
	Input.use_accumulated_input = value
