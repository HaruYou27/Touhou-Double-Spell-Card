extends FormatLabel

func _ready() -> void:
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		queue_free()
		return
		
	update_label(0)
	
var start_time := 0
var latency := 0
func _on_timer_timeout() -> void:
	start_time = Time.get_ticks_msec()
	rpc("ping", latency)
	
@rpc("authority", 'call_remote', "unreliable")
func ping(latency:int) -> void:
	update_label(latency)
	rpc("ping_server")
	
@rpc("any_peer", "call_remote", "unreliable")
func ping_server() -> void:
	latency = Time.get_ticks_msec() - start_time
	update_label(latency)
