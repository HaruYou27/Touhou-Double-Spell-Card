extends AcceptDialog

@export var timer : Timer

@onready var broadcast := PacketPeerUDP.new()
func _ready() -> void:
	get_ok_button().pressed.connect(_on_cancel_pressed)
	
	broadcast.set_broadcast_enabled(true)
	broadcast.set_dest_address('255.255.255.255', 7272)

func _on_cancel_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	timer.stop()
	hide()

var message
var text : String
var count := 0
func _on_timer_timeout():
	if count == 4:
		dialog_text = text
		count = 0
	else:
		dialog_text += '.'
		count += 1
	
	broadcast.put_var(message)

@onready var template := dialog_text
func wait_for_client(value:Array) -> void:
	dialog_text = template % value
	text = dialog_text
	message = value
	
	timer.start()
	popup()
