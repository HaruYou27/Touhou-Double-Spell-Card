extends Sprite2D

var heat := 0.0
var frame_delta := 0.0
var frame_count := 0
var next_frame : ImageTexture

@onready var tree := get_tree()
@onready var fx :ColorRect = $fx
@onready var viewport := get_viewport()
@onready var dir := DirAccess.open('user://')

const path := 'user://%d.png'

func _exit_tree() -> void:
	if frame_count:
		for _frame in range(frame_count):
			dir.remove(path % frame_count)

func _ready() -> void:
	set_process(false)
	RenderingServer.canvas_item_set_z_index(fx.get_canvas_item(), 4096)
	viewport.size_changed.connect(Callable(self,'_on_size_changed'))
	_on_size_changed()
	
##Just in case if player resize the windows.
func _on_size_changed() -> void:
	scale = global.game_rect / viewport.size
	fx.size = viewport.size

func _load_image() -> void:
	var img := Image.new()
	img.load(path % frame_count)
	next_frame = ImageTexture.create_from_image(img)

func _process(delta:float) -> void:
	heat -= delta
	if heat > 0:
		return
	
	while heat <= 0.0:
		dir.remove(path % frame_count)
		heat += frame_delta
		frame_count -= 1
	
	if frame_count > 0:
		call_deferred('_load_image')
		material.set_shader_parameter('image', next_frame)
		return
	
	hide()
	frame_count = 1
	heat = 0.0
	set_process(false)
	
	tree.paused = false
	tree.reload_current_scene()
