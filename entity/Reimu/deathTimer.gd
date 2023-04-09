extends Timer
#Because everything is paused when player at deathdoor.

signal bomb

func _ready() -> void:
	timeout.connect(_on_timeout)

func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("bomb"):
		bomb.emit()

func _on_timeout() -> void:
	Global.leveler.restart()
