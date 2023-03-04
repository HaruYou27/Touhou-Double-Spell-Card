@tool
extends SubViewportContainer

@onready var viewport :SubViewport = $SubViewport

@export var bake := false : set = _bake

func _bake(_value) -> void:
	viewport.get_texture().get_image().save_png('res://tool/shader-baker/baked.png')
