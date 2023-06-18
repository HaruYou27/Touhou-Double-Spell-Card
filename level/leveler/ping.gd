extends FormatLabel

func _ready() -> void:
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		queue_free()
		
var syncing := false
func _on_timer_timeout() -> void:
	pass
