extends Node2D
class_name global
##Signal bus Singleton, Global Variable, Static Helper Function, User setting.

##Emited by bullet when intersect player's graze Area2D.
signal bullet_graze

##Emited by item when intersect player's hitbox (not item Area2D).
signal item_collect(point)

##Emited by player's bomb node. Wipe out everything on screen.
signal bomb_impact

##Emited by player on death, or restart button.
signal restart_level

##When you want to stop player from spamming bullet.
signal can_player_shoot(value)

var leveler : Leveler
var boss :Boss
var user_data : UserData
var player : Player
var screenfx : ScreenEffect
var item_manager

##Play area rectangle.
const playground := Vector2(604, 906)

##Default resolution.
const game_rect := Vector2(1208, 906)

##Convert an InputEvent to String.
static func get_input_string(event:InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_keycode_string(event.keycode)
	
	match event.button_index:
		1:
			return 'Mouse Left'
		2:
			return 'Mouse Right'
		3:
			return 'Mouse Middle'
	
	return 'Unknown'

func _ready() -> void:
	randomize()
	
	user_data = load('user://1218622924.res')
	if user_data:
		return
		
	user_data = UserData.new()
	user_data.unlock_level("res://level/tutorial/tutorial.tscn")
	
	var fps := int(ceil(DisplayServer.screen_get_refresh_rate()))
	if fps:
		Engine.max_fps = fps
		Engine.physics_ticks_per_second = fps
		ProjectSettings.set_setting('physics/common/physics_ticks_per_second', fps)
		ProjectSettings.set_setting('application/run/max_fps', fps)

func _exit_tree() -> void:
	if Engine.is_editor_hint:
		return
	
	var viewport :Vector2 = get_viewport().size
	ProjectSettings.set_setting('display/window/size/viewport_width', viewport.x)
	ProjectSettings.set_setting('display/window/size/viewport_height', viewport.y)
	ProjectSettings.save_custom('user://override.cfg')
	ResourceSaver.save(user_data, 'user://1218622924.res', ResourceSaver.FLAG_COMPRESS)
