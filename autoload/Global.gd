extends Node2D
#The meditor, contain shared data and handle connection bettween nodes.

signal bullet_graze
signal item_collect(point)

signal bomb_impact
signal bomb_finished

var level :Leveler
var boss :Boss
var user_setting : UserSetting
var player : Player

const playground := Vector2(604, 906)
const game_rect := Vector2(1920, 1080)

func _ready():
	user_setting = load('user://save.res')
	if not user_setting:
		user_setting = UserSetting.new()
	
	var fps := int(ceil(OS.get_screen_refresh_rate()))
	if fps:
		Engine.target_fps = fps
		Engine.iterations_per_second = fps
		ProjectSettings.set_setting('physics/common/physics_fps', fps)
		ProjectSettings.set_setting('debug/settings/fps/force_fps', fps)
	randomize()

static func save_resource(path:String, resource:Resource):
	var err := ResourceSaver.save(path, resource, 32)
	if err:
		push_error('Error when saving file. Error code = ' + str(err))
	
func _exit_tree():
	if Engine.editor_hint:
		return
	
	var viewport := get_viewport()
	ProjectSettings.set_setting('display/window/size/width', viewport.size.x)
	ProjectSettings.set_setting('display/window/size/height', viewport.size.y)
	ProjectSettings.save_custom('user://override.cfg')
	save_resource('user://user_setting.res', user_setting)
