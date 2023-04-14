@tool
extends Sprite2D

@export var bake := false : set = _bake

func _bake(_value) -> void:
	print(texture.get_image().save_webp("res://tool/image-baker/", true))
