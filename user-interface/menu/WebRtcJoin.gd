extends Control

var webrtc
var connection

var SDP : String
var ICE : String

@onready var host := $Host
@onready var label := $Label
@onready var offer := $Offer
@onready var ice_timer := $IceTimer
@onready var reply := $ReplyOffer


func init() -> void:
	webrtc = WebRTCMultiplayerPeer.new()
	connection = WebRTCPeerConnection.new()
	SDP = ""
	ICE = ""
	
	webrtc.peer_connected.connect(_peer_connected)
	webrtc.peer_disconnected.connect(_peer_disconnected)
	
	connection.ice_candidate_created.connect(_ice_candidate_created)
	connection.session_description_created.connect(_session_description_created)
	connection.initialize({"iceServers": [ { "urls": ["stun:stun.l.google.com:19302"]}]})
	
	webrtc.create_mesh(2)
	webrtc.add_peer(connection, 1)
	multiplayer.multiplayer_peer = webrtc


func _ice_candidate_created(media:String, index:int, Name:String) -> void:
	ICE += media + "&&&"
	ICE += str(index) + "&&&"
	ICE += Name + "***"
	ice_timer.start()
	

func _session_description_created(type:String, sdp:String) -> void:
	SDP += sdp
	connection.set_local_description(type, sdp)


func _on_reply_offer_text_changed() -> void:
	init()
	label.text = "Processing..."
	
	
	var _str : String = (reply.text)
	var packed_str : PackedStringArray = _str.split("***", false, 1);
	
	connection.set_remote_description("offer", packed_str[1])
	
	var packed_ice = packed_str[0].split("&&&", false, 2);
	
	var media = packed_ice[0]
	var idx = packed_ice[1].to_int()
	var Name = packed_ice[2]
	
	if media is String and idx is int and Name is String:
		connection.add_ice_candidate(media, idx, Name)
	else:
		label.text = "Offer invaild."
		return

func _on_disconnect_pressed() -> void:
	webrtc.close()
	offer.hide()
	label.text = ""

func _peer_connected(id: int) -> void:
	print("******* PEER CONNECTED WITH ID %s *******" %[str(id)])
#	label.text = "Connected."
#	host.text = "Disband Party"

func _peer_disconnected(id: int) -> void:
	label.text = "Connection lost."

func _on_ice_timer_timeout():
	offer.text = ICE + SDP
	label.text = "Copy your *Offer* below and send it to your friend."
	offer.show()
