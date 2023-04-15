extends Node2D
class_name global
##Signal bus Singleton, Global Variable, Static Helper Function, User setting.

##Emited by bullet when intersect player's graze Area2D.
signal bullet_graze

##Emited by item when intersect player's hitbox (not item Area2D).
signal item_collect

##Emited by player's bomb node when finished
signal bomb_finished

signal can_player_shoot(value:bool)

var hud : HUD
var boss : Boss
var user_data : UserData
var player : Player

##Play area rectangle.
const playground := Vector2i(1080, 1620)

##Default resolution.
const game_rect := Vector2i(1920, 1080)

const main_menu := "res://user-interface/mainMenu/Menu.tscn"

@onready var tree := get_tree()

func restart_scene() -> void:
	ItemManager.Clear()
	tree.paused = false
	var tween :Tween = VisualEffect.fade2black()
	tween.finished.connect(tree.reload_current_scene)

func change_scene(scene:String) -> void:
	ItemManager.Clear()
	tree.paused = false
	var tween :Tween = VisualEffect.fade2black()
	tween.finished.connect(tree.change_scene_to_file.bind(scene))

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
	
	user_data = load('user://saveData.res')
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
	
	var window := get_window()
	ProjectSettings.set_setting('display/window/size/viewport_width', window.size.x)
	ProjectSettings.set_setting('display/window/size/viewport_height', window.size.y)
	ProjectSettings.set_setting('display/window/size/mode', window.mode)
	ProjectSettings.save_custom('user://override.cfg')
	ResourceSaver.save(user_data, 'user://saveData.res', ResourceSaver.FLAG_COMPRESS)
