extends VBoxContainer


@onready var client := ENetMultiplayerPeer.new()
func _ready() -> void:
	client.peer_connected.connect(_peer_connected)

@onready var ip := $HBoxContainer/ip
@onready var offer := $offer
func _on_join_pressed():
	client.create_client(ip.text, port)

func _peer_connected() -> void:
	multiplayer.multiplayer_peer = client
	Global.change_scene(global.lobby)

func _on_back_pressed() -> void:
	client.close()

@onready var join := $join
func _on_ip_text_changed(new_text:String) -> void:
	join.disabled = new_text.is_empty()

func _on_offer_text_changed(new_text):
	join.disabled = new_text.is_empty()

var port := 0
func _on_port_text_changed(new_text):
	port = int(new_text)
	join.disabled = port < 1024 or port > 65536
	
