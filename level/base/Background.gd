extends Sprite2D
class_name Background

var overlays : Array[Sprite2D]
@export var overlay_level := 2 : set = toggle_overlay

func _ready() -> void:
	for node in get_children():
		if node is Sprite2D:
			overlays.append(node)
			
func toggle_overlay(level:int) -> void:
	overlay_level = level
	var count := 0
	for overlay in overlays:
		if count < overlay_level:
			overlay.show()
			count += 1
		else:
			overlay.hide()
