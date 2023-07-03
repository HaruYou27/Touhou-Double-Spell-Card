extends VBoxContainer

var webrtc := WebRTCMultiplayerPeer.new()
var peer := WebRTCPeerConnection.new()

func _ready() -> void:
	return
	visibility_changed.connect(_visibility_changed)
	peer.ice_candidate_created.connect(_add_ice)
	peer.session_description_created.connect(_add_sdp)

func _visibility_changed() -> void:
	if visible:
		peer.initialize(global.ice_server)
		webrtc.create_mesh(1)
		webrtc.add_peer(peer, 1)
		multiplayer.multiplayer_peer = webrtc
		peer.create_offer()

@onready var Offer := $Offer
var offer := []
func _add_ice(media:String, index:int, Name:String) -> void:
	peer.add_ice_candidate(media, index, Name)
	
	offer.append(index)
	offer.append(media)
	offer.append(Name)
	
	prepare_offer()
	
func _add_sdp(type:String, sdp:String) -> void:
	peer.set_local_description(type, sdp)
	
	offer.append(type)
	offer.append(sdp)
	
	prepare_offer()
	
func prepare_offer() -> void:
	if offer.size() != 5:
		return
	Offer.text = var_to_str(offer)
