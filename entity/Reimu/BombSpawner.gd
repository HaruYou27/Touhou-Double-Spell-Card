extends Timer


func _on_timeout():
	var node : Node2D = bomb_scene.instantiate()
	node.global_position = get_parent().global_position
	Global.leveler.add_child(node)
