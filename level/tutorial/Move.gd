extends ColorRect

onready var player :Node2D = Global.player
onready var init_pos := player.global_position
onready var tree := get_tree()

func _ready() -> void:
	tree.call_group('player_bullet', 'stop')
	tree.create_timer(3.0).connect("timeout", self, '_timeout')
	
func _process(_delta) -> void:
	if player.global_position == init_pos:
		return
	
func _timeout() -> void:
	
