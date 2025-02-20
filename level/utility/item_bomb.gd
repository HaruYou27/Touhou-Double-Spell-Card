extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.is_multiplayer_authority() and body is not GrazeBody:
		queue_free()
	body.add_bomb.emit()
