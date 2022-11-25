extends Sprite

var heat := 0.0
var frame_delta := 0.0
var frame_count := 1
var next_frame :ImageTexture

onready var tree := get_tree()
onready var fx :ColorRect = $fx
onready var viewport := get_viewport()
onready var dir := Directory.new()

const path := 'user://%d.png'

func _ready():
	set_process(false)
	VisualServer.canvas_item_set_z_index(fx.get_canvas_item(), 4096)
	viewport.connect("size_changed", self, '_on_size_changed')
	dir.open('user://')
	_on_size_changed()
	
func _on_size_changed():
	scale = Global.game_rect / viewport.size
	fx.rect_size = viewport.size
	ProjectSettings.set_setting('display/window/size/width', viewport.size.x)
	ProjectSettings.set_setting('display/window/size/height', viewport.size.y)

func _load_image() -> void:
	var img := Image.new()
	img.load(path % frame_count)
	next_frame.create_from_image(img)

func _process(delta) -> void:
	heat -= delta
	if heat > 0:
		return
	
	while heat <= 0.0:
		dir.remove(path % frame_count)
		heat += frame_delta
		frame_count -= 1
	
	if frame_count > 0:
		call_deferred('_load_image')
		texture = next_frame
		return
	
	hide()
	frame_count = 1
	heat = 0.0
	set_process(false)
	
	tree.paused = false
	tree.change_scene(Global.save_data.last_level)
