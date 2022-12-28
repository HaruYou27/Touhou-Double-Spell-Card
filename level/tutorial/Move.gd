extends Control

onready var tree := get_tree()

var player : Player
var init_pos : Vector2

func _ready():
	tree.call_group('player_bullet', 'stop')
	Global.connect("player_entered", self, "_start")
	set_process(false)
	
func _start(node:Node2D):
	player = node
	init_pos = node.global_position
	set_process(true)
	
func _process(_delta):
	if player.global_position != init_pos:
		Global.emit_signal("next_level")
		return
	
func _on_Timer_timeout():
	add_child(Dialogic.start('/tutorial/move'))
