extends Node

onready var viewport := get_viewport()
onready var screenshot := viewport.get_texture()
onready var tree := get_tree()
onready var thread := Thread.new()

onready var fx :ColorRect = $ColorRect
onready var timer :Timer = $Timer
onready var sprite :Sprite = $Sprite

var frame := 0
var heat := 0.0
var frame_delta := 0.0

const path := 'user://%d.png'

func _ready() -> void:
	VisualServer.canvas_item_set_z_index($ColorRect.get_canvas_item(), 4096)
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
	if heat <= 0:
		frame -= 1
		heat += frame_delta
		
		var img := Image.new()
		img.load(path % frame)
		var tex := ImageTexture.new()
		tex.create_from_image(img)
		sprite.texture = tex
	else:
		heat -= delta
		
	if frame:
		return
		
	remove_child(fx)
	remove_child(sprite)
		
	pause_mode = Node.PAUSE_MODE_INHERIT
	set_process(false)
		
	tree.reload_current_scene()

func _on_Timer_timeout():
	thread.wait_to_finish()
	thread.start(self, '_record')
