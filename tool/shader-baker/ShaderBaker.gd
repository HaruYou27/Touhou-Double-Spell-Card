@tool
extends SubViewportContainer


@export var bake := false : set = _bake

func _bake(_value) -> void:
	$SubViewport.get_texture().get_image().save_png('res://tool/shader-baker/baked.png')
