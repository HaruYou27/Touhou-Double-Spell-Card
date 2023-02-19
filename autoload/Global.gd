extends Node2D
#The meditor, contain shared data and handle connection bettween nodes.

signal bullet_graze
signal item_collect(point)
signal bomb_impact

var leveler :Leveler
var boss :Boss
var user_data : UserData
var player : Player
var score :Score

var can_shoot := true
var death_timer := 0.3

const playground := Vector2(604, 906)
const game_rect := Vector2(1920, 1080)

func _ready():
	user_data = load('user://save.res')
	if not user_data:
		user_data = UserData.new()
	
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
	save_resource('user://user_data.res', user_data)
