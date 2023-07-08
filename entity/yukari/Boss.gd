extends Area2D
class_name Boss


var point := 0

func _hit() -> void:
	point += 1

func _on_body_entered(body) -> void:
	if body is Player:
		body._hit()

func start() -> void:
	create_tween().tween_property(self, 'modulate', Color.WHITE, 1.)

func _on_level_timer_timeout():
	Global.item_manager.spawn_item(point, global_position)
	point = 0
