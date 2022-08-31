extends Timer

signal bomb

onready var tree = get_tree()

func _ready() -> void:
	wait_time = Global.save.death_timer
	
func _unhandled_input(event):
	if event.is_action_pressed("bomb"):
		tree.paused = false
		emit_signal("bomb")
