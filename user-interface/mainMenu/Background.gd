extends Node2D

var backgrounds : Array[Background]
var current_bg : Background

func _ready() -> void:
	for node in get_children():
		if node is Background:
			backgrounds.append(node)
			node.hide()
	
	current_bg = backgrounds.pick_random()
	current_bg.show()

func set_background(idx:int, overlay_level:int) -> void:
	current_bg.hide()
	
	current_bg = backgrounds[idx]
	current_bg.show()
	current_bg.overlay_level = overlay_level
