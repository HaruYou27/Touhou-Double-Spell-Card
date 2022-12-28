extends Node2D
#Shared data, the midground allow objects to talk to each others.

#Bullet signal
signal graze
signal collect(point)

#Player signal
signal player_entered
signal bomb
signal dying
signal impact
signal died

signal next_level

var config : Config
var player : Player setget _set_player

const playground := Vector2(646, 904)
const game_rect := Vector2(1280, 960)

func _set_player(node:Player):
	player = node
	emit_signal("player_entered", node)

func _ready():
	config = load('user://save.res')
	Input.use_accumulated_input = false
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
