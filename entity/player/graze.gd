extends StaticBody2D

signal update_score(value)


func _collect(value:int) -> void:
	emit_signal("update_score", value)

func _hit() -> void:
	emit_signal("update_score", 1)
