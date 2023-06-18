extends VBoxContainer

@export var ip : FormatLabel
func  _ready() -> void:
	visibility_changed.connect(_on_back_pressed)
	server.peer_connected.connect(_peer_connected)

@export var port : LineEdit
@export var host_button : SFXButton
@onready var orb :ShaderMaterial = $Kishin.material
var server := ENetMultiplayerPeer.new()
func _on_host_pressed() -> void:
	server.create_server(int(port.text), 1)
	host_button.text = 'Waiting for connection.'
	host_button.disabled = true
	orb.set_shader_parameter('spin', true)

## Reset stuff
func _on_back_pressed() -> void:
	host_button.text = 'Host Party'
	host_button.disabled = false
	orb.set_shader_parameter('spin', false)
	server.close()
	
	var ips := IP.get_local_addresses()
	if ips.is_empty():
		return
	ip.update_label(ips[0])

@onready var root := get_tree().current_scene
func _peer_connected() -> void:
	root.change_menu
