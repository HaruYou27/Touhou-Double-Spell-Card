extends Timer

signal bomb

@onready var bomb_button := Global.user_data.bomb_button

func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("bomb") or (bomb_button and event is InputEventScreenTouch and event.index):
		bomb.emit()

func _on_timeout():
	Global.restart_scene()
