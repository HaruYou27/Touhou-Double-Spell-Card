extends Node2D
## Public variables and signals

## Emit when player change graphic settings.
signal update_graphic
var leveler: Leveler

const main_menu := "res://user-interface/menu/menu.tscn"
const config_path := 'user://saveData.res'

var last_man_standing := false

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
