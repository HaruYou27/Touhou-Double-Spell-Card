var sprite : RID

func create(data:Gunpowder):
	sprite = VisualServer.canvas_item_create()
	VisualServer.canvas_item_set_parent(sprite, Global.canvas)
	VisualServer.canvas_item_set_z_index(sprite, data.z_index)
	VisualServer.canvas_item_add_texture_rect(sprite, Rect2(
		data.offset, data.texture_size), data.texture)
	VisualServer.canvas_item_set_light_mask(sprite, 0)
	if data.material:
		VisualServer.canvas_item_set_material(sprite, data.material)

func draw(transform):
	VisualServer.canvas_item_set_transform(sprite, transform)
	
func free_rid():
	VisualServer.free_rid(sprite)
