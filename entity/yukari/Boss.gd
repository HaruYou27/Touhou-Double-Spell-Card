extends Area2D
class_name Boss

var point := 0

func _hit() -> void:
	point += 1

func _on_body_entered(body) -> void:
	if body is Player:
		body.hit()

func spawn_item():
	ItemManager.spawn_item(point, global_position)
	point = 0
