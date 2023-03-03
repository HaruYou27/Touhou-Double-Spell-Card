@tool
extends SubViewportContainer

@onready var viewport :SubViewport = $SubViewport

@export (bool) var bake : set = _bake

func _bake(_value):
	viewport.get_texture().get_data().save_png('res://tool/shader-baker/baked.png')
