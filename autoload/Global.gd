extends Node2D
#The meditor, contain shared data and handle connection bettween nodes.

#Bullet signal
signal bullet_graze
signal item_collect(point)
signal spawn_item(quantity)

#Player signal
signal player_moved(new_pos)
signal player_bombed
signal player_reward
signal player_dying
signal player_died
signal bomb_impact

signal next_level

var config : Config

const playground := Vector2(646, 904)
const game_rect := Vector2(1280, 960)

func _ready():
	config = load('user://save.res')
	if not config:
		config = Config.new()
		var fps :int = OS.get_screen_refresh_rate()
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
