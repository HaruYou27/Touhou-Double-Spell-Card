extends Control

onready var tree := get_tree()

var player : Player
var init_pos : Vector2

func _ready():
	tree.call_group('player_bullet', 'stop')
	Global.connect("player_moved", self, "_moving")
	
func _moving(pos:Vector2):
	if not init_pos:
		init_pos = pos
	elif init_pos != pos:
		Global.emit_signal("next_level")
	
func _on_Timer_timeout():
	add_child(Dialogic.start('/tutorial/move'))
