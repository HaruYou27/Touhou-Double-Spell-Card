tool
extends ViewportContainer

onready var viewport :Viewport = $Viewport

export (bool) var bake setget _bake

func _bake(_value):
	viewport.get_texture().get_data().save_png('res://tool/shader-baker/baked.png')
