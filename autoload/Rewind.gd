extends Node

onready var screenshot := get_viewport().get_texture()
onready var timer :Timer = $Timer
onready var sprite :AnimatedSprite = $AnimatedSprite
onready var tree := get_tree()

var frames := []

func _ready() -> void:
	sprite.connect("animation_finished", sprite.frames, 'clear')
	sprite.connect("animation_finished", sprite, 'stop')

func _record() -> void:
	frames.append(screenshot.get_data())

func rewind(level:PackedScene) -> void:
	timer.stop()
	for frame in frames:
		var img := ImageTexture.new()
		sprite.frames.add_frame('default', img)
	sprite.frames.set_animation_speed('default', frames.size() / 3.0)
	sprite.play("default", true)
	frames.clear()
	sprite.connect("animation_finished", tree, 'change_scene_to', [level], 4)
