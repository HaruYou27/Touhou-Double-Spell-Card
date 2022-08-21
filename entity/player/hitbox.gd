extends StaticBody2D

signal player_deathdoor

func _hit() -> void:
	emit_signal("player_deathdoor")
	
