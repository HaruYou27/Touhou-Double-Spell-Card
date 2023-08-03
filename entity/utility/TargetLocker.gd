extends Node2D
class_name TargetLocker

func transform_barrel() -> void:
	if not Global.player1:
		return
	
	var direction1 : Vector2 = (Global.player1.get_node("Player").global_position - global_position)
	if is_instance_valid(Global.player2):
		var direction2 : Vector2 = (Global.player2.get_node("Player").global_position - global_position)
		
		if direction2.length() < direction1.length():
			rotation = direction2.angle()
	else:
		rotation = direction1.angle()
