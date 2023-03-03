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
var score : Score

const playground := Vector2(604, 906)
const game_rect := Vector2(1920, 1080)

func _ready() -> void:
	user_data = load('user://save.res')
	if not user_data:
		user_data = UserData.new()
	
	var fps := int(ceil(DisplayServer.screen_get_refresh_rate()))
	if fps:
		Engine.max_fps = fps
		Engine.physics_ticks_per_second = fps
		ProjectSettings.set_setting('physics/common/physics_fps', fps)
		ProjectSettings.set_setting('debug/settings/fps/force_fps', fps)
	randomize()

static func save_resource(path:String, resource:Resource) -> void:
	var err := ResourceSaver.save(resource, path, 32)
	if err:
		push_error('Error when saving file. Error code = ' + str(err))
	
func _exit_tree() -> void:
	if Engine.is_editor_hint:
		return
	
	var viewport := get_viewport()
	ProjectSettings.set_setting('display/window/size/viewport_width', viewport.size.x)
	ProjectSettings.set_setting('display/window/size/viewport_height', viewport.size.y)
	ProjectSettings.save_custom('user://override.cfg')
	save_resource('user://user_data.res', user_data)
