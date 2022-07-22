extends Reference
class_name Global_canvas
#Draw entities in global shared canvas item. No rotate, no shader.

var data : Resource

func create(dat) -> void:
	data = dat

func draw(transform) -> void:
	VisualServer.canvas_item_add_texture_rect(Global.canvas, Rect2(
		transform.get_origin(), data.texture_size), data.texture)

func free_rid() -> void:
	pass
