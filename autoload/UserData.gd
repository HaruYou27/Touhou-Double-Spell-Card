extends Resource
class_name UserData

#Graphic
@export var rewind := false
@export var full_particle := true
@export var dynamic_background := true

#Controls
@export var sentivity := 1.0
@export var raw_input := true : set = _set_raw_input
@export var drag_bind : InputEvent : set = _bind_drag
@export var bomb_bind : InputEvent : set = _bind_bomb

##User data
@export var scores := {}

func _bind_drag(event:InputEvent) -> void:
	InputMap.action_erase_events('drag')
	InputMap.action_add_event('drag', event)
	
func _bind_bomb(event:InputEvent) -> void:
	InputMap.action_erase_events('bomb')
	InputMap.action_add_event('bomb', event)

func _set_raw_input(value:bool) -> void:
	Input.use_accumulated_input = value

func unlock_level(key:String) -> void:
	var score = Score.new()
	var path := 'user://' + str(randi()) + '.res'
	ResourceSaver.save(score, path)
	scores[key] = path
