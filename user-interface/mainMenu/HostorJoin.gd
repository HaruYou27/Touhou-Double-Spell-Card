extends ConfirmationDialog

@onready var host : Button = get_cancel_button()
@onready var join : Button = get_ok_button()
func _ready():
	host.set_script(SFXButton)
	host.pressed.connect(_on_host_pressed)
	
	join.set_script(SFXButton)

@export var host : AcceptDialog
@export var network_error : AcceptDialog
func _on_host_pressed() -> void:
	var enet := ENetMultiplayerPeer.new()
	var ip := IP.get_local_addresses()
	if not ip.size():
		network_error.popup()
		return
	
	var port := 8000
	while enet.create_server(port, 1):
		port += 1
	
	multiplayer.multiplayer_peer = enet	
	host.wait_for_client([ip[0], port])
