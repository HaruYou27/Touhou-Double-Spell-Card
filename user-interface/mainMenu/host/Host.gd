extends Control

@export var address : FormatLabel

func host():
	var ip := IP.get_local_addresses()
	if not ip.size():
		return
	
	var enet := ENetMultiplayerPeer.new()
	var port := 8000
	while enet.create_server(port, 1):
		port += 1
	
	address.update_label([ip[0], port])
