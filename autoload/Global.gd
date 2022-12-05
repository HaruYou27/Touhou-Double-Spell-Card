extends Node2D

signal graze
signal collect
signal bomb

signal impact
signal next_level

var config : Config
var player setget _set_player
var boss

const fade_black = Color(0.129412, 0.129412, 0.129412)
const fade_trans = Color(0.129412, 0.129412, 0.129412, 0)
const fade_time = .5

const playground := Vector2(646, 904)
const game_rect := Vector2(1280, 960)

func _set_player(value:Node2D):
	player = value
	BulletFx.target = value
	ItemManager.target = value

func _ready():
	config = load('user://save.res')
	Input.use_accumulated_input = false
	if not config:
		config = Config.new()
		var fps := OS.get_screen_refresh_rate()
		if fps:
			fps += 1
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
	var viewport := get_viewport()
	ProjectSettings.set_setting('display/window/size/width', viewport.size.x)
	ProjectSettings.set_setting('display/window/size/height', viewport.size.y)
	ProjectSettings.save_custom('user://override.cfg')
	save_resource('config.res', config)
