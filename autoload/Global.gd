extends Node2D
#god

signal bullet_graze
signal item_collect(point)
signal bomb_impact

signal restart_level

signal can_player_shoot(value)

var leveler : Leveler
var boss :Boss
var user_data : UserData
var player : Player
var screenfx : ScreenEffect
var item_manager

const playground := Vector2(604, 906)
const game_rect := Vector2(1920, 1080)

func _ready() -> void:
	randomize()
	
	user_data = load('user://727564643146467234.res')
	if user_data:
		return
		
	user_data = UserData.new()
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
	ResourceSaver.save(user_data, 'user://727564643146467234.res', 32)
