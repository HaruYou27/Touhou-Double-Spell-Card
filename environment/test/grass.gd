extends TileMap

func _process(_delta):
	material.set_shader_param('viewport_transform', get_viewport_transform())
