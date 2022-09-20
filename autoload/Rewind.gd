extends Node

onready var viewport := get_viewport()
onready var screenshot := viewport.get_texture()
onready var tree := get_tree()
onready var thread := Thread.new()

onready var fx :ColorRect = $ColorRect
onready var timer :Timer = $Timer
onready var sprite :Sprite = $Sprite

var frame := 0
var max_frame := 0
var heat := 0.0
var frame_delta := 0.0

const path := 'user://%d.png'

func _ready() -> void:
	VisualServer.canvas_item_set_z_index(fx.get_canvas_item(), 4096)
	remove_child(fx)
	remove_child(sprite)
	set_process(false)

func _record() -> void:
	screenshot.get_data().save_png(path % frame)
	frame += 1

func rewind() -> void:
	timer.stop()
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	add_child(fx)
	add_child(sprite)
	
	sprite.scale = Global.game_rect / viewport.size
	frame_delta = 2.0 / frame
	
	set_process(true)

func _process(delta) -> void:
	heat -= delta
	
	if heat > 0:
		return
	
	while heat <= 0.0:
		heat += frame_delta
		frame -= 1
	
	if frame >= 0:
		var img := Image.new()
		img.load(path % frame)
		var tex := ImageTexture.new()
		tex.create_from_image(img)
		sprite.texture = tex
		return
	
	remove_child(fx)
	remove_child(sprite)
	
	heat = 0.0
	pause_mode = Node.PAUSE_MODE_INHERIT
	set_process(false)
	
	tree.paused = false
	tree.reload_current_scene()
	if max_frame < frame:
		max_frame = frame

func _on_Timer_timeout() -> void:
	thread.wait_to_finish()
	thread.start(self, '_record')
	
func _exit_tree() -> void:
	var dir := Directory.new()
	dir.open('user://')
	
	while not max_frame:
		max_frame -= 1
		dir.remove(path % max_frame)
	
