extends Node2D
## Public variables and signals

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
const config_path := 'user://saveData.res'

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
	if not Engine.is_editor_hint:
		print(Engine.get_license_text())
	#multiplayer.peer_disconnected.connect(_peer_disconnected)
	user_data = load(config_path)
	if user_data:
		return
		
	user_data = UserData.new()

func game_pause()
	leveler.pause.pressed.emit()

func game_over()
	Global.leveler.animator.stop()