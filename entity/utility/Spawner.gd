extends Node

@export var scene : PackedScene
@export var container : Node

@onready var tree := get_tree()

var tick := false
func _on_timer_timeout():
	if tick:
		tick = false
	else:
		tick = true
		
	var enemy :PathFollower2D = scene.instantiate()
	enemy.reverse = tick
	container.add_child(enemy)
	tree.call_group("Enemy 0", "_track")
