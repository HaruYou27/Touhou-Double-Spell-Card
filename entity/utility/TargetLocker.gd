extends Marker2D

func _track() -> void:
	var direction1 : Vector2
	if is_instance_valid(Global.player2):
		direction1 = (Global.player1.global_position - global_position)
		var direction2 = (Global.player2.global_position - global_position)
		
		if direction2.length() < direction1.length():
			rotation = direction2.angle()
	else:
		rotation = direction1.angle()
