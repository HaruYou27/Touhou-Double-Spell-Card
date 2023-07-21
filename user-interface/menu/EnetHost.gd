extends Control

var socket := PacketPeerUDP.new()
var server := ENetMultiplayerPeer.new()
func  _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	server.peer_connected.connect(_peer_connected)
	
	broadcast_timer.timeout.connect(socket.put_var.bind(server_info))
	socket.set_broadcast_enabled(true)
	socket.set_dest_address("255.255.255.255", 4343)
	update_ip()
	
func _visibility_changed() -> void:
	update_ip()

@onready var host := $EnetHost/host
@onready var animator := $EnetHost/AnimationPlayer
@onready var broadcast_timer := $EnetHost/BroadcastTimer
func _on_host_pressed() -> void:
	if server.get_connection_status():
		server.close()
		animator.play("RESET")
		broadcast_timer.stop()
		return
	
	var err := server.create_server(port, 1)
	if err:
		host.text = 'Error ' + error_string(err)
		server.close()
		broadcast_timer.stop()
		return
		
	server_info.clear()
	server_info.append(port)
	server_info.append(ip.text)
	broadcast_timer.start()
	animator.play("waitting")
	multiplayer.multiplayer_peer = server
	
var server_info := []
func _peer_connected(_id) -> void:
	animator.stop()
	host.text = 'Connected'
	
@onready var ip := $EnetHost/HBoxContainer/ip
func update_ip() -> void:
	var ips := IP.get_local_addresses()
	if ips.is_empty():
		return
	ip.text = ips[0]

var port := 6567
func _on_port_text_changed(new_text:String):
	port = int(new_text)
	host.disabled = port <= 1024 or port >= 65536
