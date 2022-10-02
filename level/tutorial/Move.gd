extends ColorRect

onready var player :Node2D = Global.player
onready var init_pos := player.global_position
onready var tree := get_tree()

func _ready() -> void:
	tree.call_group('player_bullet', 'stop')
	
func _process(_delta) -> void:
	if player.global_position == init_pos:
		Global.emit_signal("next_level")
		return
		
	Global.emit_signal("next_level")
	tree.call_group('player_bullet', 'start')
	set_process(false)
	
func _on_Timer_timeout():
	pass # Replace with function body.
