@tool
extends SubViewport

@export var bake := false : set = _bake

@onready var texture := get_texture()

func _bake(_value) -> void:
	print(texture.get_image().save_webp("res://tool/image-baker/", true))
