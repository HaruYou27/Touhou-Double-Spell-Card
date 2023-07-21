extends AcceptDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_disconnected.connect(popup_centered)
