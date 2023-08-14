extends Node2D
class_name global
##god

############ GLOBAL GAMEPLAY
## Emited by bullet when intersect player's graze Area2D.
signal bullet_graze

## Emited by item when intersect player's hitbox (not item Area2D).
signal item_collect

var hud : HUD
var screen_effect : ScreenEffect
var player1 : Node2D
var player2 : Node2D
var last_man_standing := false
func _peer_disconnected() -> void:
	player2 = null

##Play area rectangle.
const playground := Vector2i(540, 852)

##Default resolution.
const game_rect := Vector2i(540, 960)
#######################

################ USER INTERFACE
const main_menu := "res://user-interface/menu/menu.tscn"
const ice_server := {
		"iceServers": [ { "urls": [
			"stun:stun.l.google.com:19302",
			'stun1.l.google.com:19302',
			'stun2.l.google.com:19302',
			'stun3.l.google.com:19302',
			'stun4.l.google.com:19302',
			'stun.ekiga.net',
			'stun.ideasip.com',
			'stun.rixtelecom.se',
			'stun.schlund.de',
			'stun.stunprotocol.org:3478',
			'stun.voiparound.com',
			'stun.voipbuster.com',
			'stun.voipstunt.com',
			'stun.voxgratia.org',] } ]
	}

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
####################

######## NETWORKING
##Difference in absolute time between the two clocks.
var offset := 0
func sync_clock() -> void:
	offset = Time.get_ticks_msec()
	rpc('sync_host_clock')
	
@rpc("reliable", "any_peer")
func sync_host_clock() -> void:
	rpc('calculate_offset', Time.get_ticks_msec())
	
@rpc("reliable")
func calculate_offset(host_time:int) -> void:
	offset = host_time - ((Time.get_ticks_msec() - offset) / 2)
	
func get_host_time() -> int:
	return Time.get_ticks_msec() + offset
###########

########## USER CONFIG
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
###############
