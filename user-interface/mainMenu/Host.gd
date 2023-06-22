extends VBoxContainer

var server := ENetMultiplayerPeer.new()
var webrtc := WebRTCMultiplayerPeer.new()
var webrtc_peer := WebRTCPeerConnection.new()
func  _ready() -> void:
	visibility_changed.connect(_on_back_pressed)
	server.peer_connected.connect(_peer_connected.bind(server))
	update_ip()

@onready var host := $host
@onready var error := $"../main/error"
@onready var animator := $AnimationPlayer
func _on_host_pressed() -> void:
	if server.create_server(port, 1) and webrtc_peer.initialize(global.ice_server):
		error.popup_centered()
		server.close()
		webrtc_peer.close()
		return
		
	webrtc.add_peer(webrtc_peer, 1)
	webrtc_peer.ice_candidate_created.connect(_add_ice)
	webrtc_peer.session_description_created.connect(_add_sdp)
	webrtc_peer.create_offer()
	
	animator.play("waitting")
	
var server_info := []
func _add_ice(media:String, index:int, Name:String) -> void:
	webrtc_peer.add_ice_candidate(media, index, Name)
	
	server_info.append(index)
	server_info.append(media)
	server_info.append(Name)
	
func _add_sdp(type:String, sdp:String) -> void:
	webrtc_peer.set_local_description(type, sdp)
	
	server_info.append(type)
	server_info.append(sdp)
	
func _peer_connected(multiplayer_peer:MultiplayerPeer) -> void:
	multiplayer.multiplayer_peer = multiplayer_peer
	Global.change_scene(global.lobby)
	
## Reset stuff
func _on_back_pressed() -> void:
	host.text = 'Host Party'
	host.disabled = false
	animator.play("RESET")
	server.close()
	webrtc.close()
	webrtc_peer.close()
	server_info.clear()	
	update_ip()

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
	host.disabled = port < 1024 or port > 65536
