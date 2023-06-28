extends Node

@export var scene1 : PackedScene
@export var scene2 : PackedScene
@export var container : Node

var tick := false
func _on_timer_timeout():
	if tick:
		tick = false
	else:
		tick = true
		
	var enemy :PathFollower2D = scene1.instantiate()
	enemy.reverse = tick
	container.add_child(enemy)
	
