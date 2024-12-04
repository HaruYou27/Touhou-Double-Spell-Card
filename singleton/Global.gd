extends Node2D
## Public variables and signals

## Emited by bullet when intersect player's graze Area2D.
signal bullet_graze

## Emited by item when intersect player's hitbox (not item Area2D).
signal item_collect

## Emit when player change graphic settings.
signal update_graphic

var hud: HUD
var leveler: Leveler

var player1: Player
var player2: Player
## The game will end if both players die.
var last_man_standing := false

func _peer_disconnected() -> void:
	return
	player2 = null

const main_menu := "res://user-interface/menu/menu.tscn"

var offset := 0
func sync_clock() -> void:
	offset = Time.get_ticks_usec()
	rpc('sync_host_clock')
	
@rpc("reliable", "any_peer")
func sync_host_clock() -> void:
	rpc('calculate_offset', Time.get_ticks_usec())
	
@rpc("reliable")
func calculate_offset(host_time:int) -> void:
	offset = host_time - ((Time.get_ticks_usec() - offset) / 2)
	
func get_host_time() -> int:
	return Time.get_ticks_usec() + offset

var user_data : UserData
func _ready() -> void:
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	user_data = load('user://saveData.res')
	if user_data:
		return
		
	user_data = UserData.new()
	
##Save user config.
func _exit_tree() -> void:
	if Engine.is_editor_hint:
		return
	
	var window := get_window()
	ProjectSettings.set_setting('display/window/size/viewport_width', window.size.x)
	ProjectSettings.set_setting('display/window/size/viewport_height', window.size.y)
	ProjectSettings.set_setting('display/window/size/mode', window.mode)
	ProjectSettings.save_custom('user://override.cfg')
	ResourceSaver.save(user_data, 'user://saveData.res', ResourceSaver.FLAG_COMPRESS)
