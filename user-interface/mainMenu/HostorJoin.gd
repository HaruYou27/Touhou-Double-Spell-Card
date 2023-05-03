extends ConfirmationDialog

@onready var host : Button = get_cancel_button()
@onready var join : Button = get_ok_button()
func _ready():
	multiplayer.multiplayer_peer = enet
	
	host.set_script(SFXButton)
	host.pressed.connect(_on_host_pressed)
	
	join.set_script(SFXButton)

@onready var enet := ENetMultiplayerPeer.new()
@export var waiting : AcceptDialog
func _on_host_pressed() -> void:
	var ip := IP.get_local_addresses()
	if not ip.size():
		OS.alert('Please connect to a network (No internet required).', 'No Connection')
		return
	
	var port := 8000
	while enet.create_server(port, 1):
		port += 1
	
	waiting.wait_for_client([ip[0], port])
