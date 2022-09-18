extends Node

onready var viewport := get_viewport()
onready var screenshot := viewport.get_texture()
onready var tree := get_tree()

onready var fx :ColorRect = $ColorRect
onready var timer :Timer = $Timer
onready var sprite :AnimatedSprite = $AnimatedSprite

var frame := 0
var frames := []

func _ready() -> void:
	VisualServer.canvas_item_set_z_index($ColorRect.get_canvas_item(), 4096)
	remove_child(fx)

func _record() -> void:
	var texture := ImageTexture.new()
	texture.create_from_image(screenshot.get_data(), 0)
	frames.append(texture)
	frame += 1

func rewind() -> void:
	ItemManager
	timer.stop()
	pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(fx)
	
	sprite.scale = Global.game_rect / viewport.size
	for f in frames:
		sprite.frames.add_frame('default', f)
	sprite.frames.set_animation_speed('default', frame / 3.0)
	sprite.play("default", true)
	sprite.connect("animation_finished", tree, 'reload_current_scene', [], 4)

func _on_AnimatedSprite_animation_finished():
	remove_child(fx)
	sprite.frames.clear('default')
	sprite.stop()
	frames.clear()
