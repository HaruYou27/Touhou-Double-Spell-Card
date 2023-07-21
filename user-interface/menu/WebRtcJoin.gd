extends Control

var webrtc := WebRTCMultiplayerPeer.new()
var peer_remote := WebRTCPeerConnection.new()
var peer_local := WebRTCPeerConnection.new()

func _ready() -> void:
	webrtc.peer_connected.connect(_peer_connected)
	webrtc.peer_disconnected.connect(_peer_disconnected)
	
	peer_local.ice_candidate_created.connect(_ice_candidate_created)
	peer_remote.session_description_created.connect(_add_sdp)
	
	webrtc.add_peer(peer_remote, 1)
	webrtc.add_peer(peer_local, 2)
	
@onready var offer := $Offer

var Offer := []
func _ice_candidate_created(media:String, index:int, Name:String) -> void:
	Offer.append(media)
	Offer.append(index)
	Offer.append(Name)
	
	if peer_local.get_gathering_state() == WebRTCPeerConnection.GATHERING_STATE_COMPLETE:
		offer.text = var_to_str(Offer)
		offer.show()
		label.text = 'Copy your *Offer* above and send it to your friend.'
		label.show()
	
func _add_sdp(type:String, sdp:String) -> void:
	peer_local.set_local_description(type, sdp)
	Offer.append(sdp)

@onready var label := $Label
@onready var reply := $ReplyOffer
func _on_reply_offer_text_changed() -> void:
	var remote_offer = str_to_var(reply.text)
	if not (remote_offer is Array or (remote_offer.size() - 1) % 3):
		label.text = 'Offer invaild.'
		return
		
	Offer.clear()
	webrtc.create_mesh(2)
	peer_remote.initialize(global.ice_server)
	peer_local.initialize(global.ice_server)
	peer_remote.set_remote_description('offer', remote_offer[0])
	
	#Add ICE
	for index in range(1, remote_offer.size(), 3):
		var media = remote_offer[index]
		var idx = remote_offer[index + 1]
		var Name = remote_offer[index + 2]
		
		if media is String and index is int and Name is String:
			peer_remote.add_ice_candidate(media, idx, Name)
		else:
			label.text = 'Offer invaild.'
			return
			
	multiplayer.multiplayer_peer = webrtc

func _on_disconnect_pressed() -> void:
	webrtc.close()
	offer.hide()
	label.text = 'Copy your *Offer* above and send it to your friend.'
	label.hide()

func _peer_connected() -> void:
	label.text = 'Connected.'

func _peer_disconnected() -> void:
	label.text = 'Connection lost.'
