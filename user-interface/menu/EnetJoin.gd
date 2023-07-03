extends VBoxContainer

@onready var client := ENetMultiplayerPeer.new()
@onready var animator := $AnimationPlayer
@onready var timer := $Timer
func _ready() -> void:
	client.peer_connected.connect(_peer_connected)
	socket.bind(4343, '255.255.255.255')
	visibility_changed.connect(_visibility_changed)
	
func _visibility_changed() -> void:
	if visible:
		timer.start()
		return
	timer.stop()

@onready var ip := $HBoxContainer/ip
@onready var port_label := $HBoxContainer/port
@onready var join_button := $Join
func join(ip_addr:String, port_num:int) -> void:
	if client.get_connection_status():
		client.close()
		animator.play("RESET")
	
	var err := client.create_client(ip_addr, port_num)
	if err:
		join_button.text = 'Error ' + error_string(err)
	else:
		animator.play("connecting")
		multiplayer.multiplayer_peer = client

func _peer_connected(_id) -> void:
	Global.sync_clock()
	animator.stop()
	join_button.text = 'Connected'

var port := 6567
func _on_port_text_changed(new_text):
	port = int(new_text)
	if port <= 1024 or port >= 65536:
		join_button.disabled = true
		join_button.text = 'Invaild port'
		return
	else:
		join_button.disabled = false
		join_button.text = 'Join Party'

@onready var list := $"../ItemList"
var server_list := {}
var socket := PacketPeerUDP.new()
func _on_timer_timeout() -> void:
	for server in server_list.values():
		if server[3] >= 5:
			server_list.erase(server[1])
			list.remove_item(server[2])
		else:
			server[3] += 1
	
	for packet in range(socket.get_available_packet_count()):
		var server_info : Array = socket.get_var()
		
		if not server_info[0] is int or not server_info[1] is String:
			continue
		
		if server_list.has(server_info[1]):
			var old_info : Array = server_list[server_info[1]]
			old_info[0] = server_info[0]
			old_info[3] = 0
			continue
			
		server_info.append(list.add_item(server_info[1]))
		server_info.append(0)
		server_list[server_info[1]] = server_info

func _on_item_list_item_clicked(index:int, _at_position, _mouse_button_index) -> void:
	var ip_addr : String = list.get_item_text(index)
	join(ip_addr, server_list[ip_addr][0])

func _on_join_pressed() -> void:
	join(ip.text, port)
