extends VBoxContainer

var server := ENetMultiplayerPeer.new()
func  _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	server.peer_connected.connect(_peer_connected)
	socket.set_broadcast_enabled(true)
	socket.set_dest_address("255.255.255.255", 4343)
	update_ip()
	
func _visibility_changed() -> void:
	if visible:
		return
	
	animator.play("RESET")
	server.close()
	server_info.clear()
	update_ip()

@onready var host := $host
@onready var animator := $AnimationPlayer
@onready var timer := $Timer
func _on_host_pressed() -> void:
	var err := server.create_server(port, 1)
	if err:
		host.text = 'Error ' + error_string(err)
		server.close()
		return
	animator.play("waitting")
	server_info.append(port)
	server_info.append(ip.text)
	timer.start()
	
var server_info := []
func _peer_connected() -> void:
	multiplayer.multiplayer_peer = server
	Global.change_scene(global.lobby)
	
@onready var ip := $HBoxContainer/ip
func update_ip() -> void:
	var ips := IP.get_local_addresses()
	if ips.is_empty():
		host.disabled = true
		return
	host.disabled = false
	ip.text = ips[0]

var port := 0
func _on_port_text_changed(new_text:String):
	port = int(new_text)
	host.disabled = port <= 1024 or port >= 65536

var socket := PacketPeerUDP.new()
func _on_timer_timeout():
	socket.put_var(server_info)
