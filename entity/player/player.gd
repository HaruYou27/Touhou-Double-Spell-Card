extends StaticBody2D
class_name Player

signal die

onready var hitSFX : AudioStreamPlayer = $hitSFX
onready var focus_layer : Sprite = $focus
onready var graze : StaticBody2D = $graze
onready var animation :AnimationPlayer = $AnimationPlayer
onready var tree := get_tree()

onready var bombs :int = Global.save_data.init_bomb
onready var death_time = Global.save_data.death_time

var input :Node

export (PackedScene) var bomb_scene

func _ready() -> void:
	Global.player = self
	if Global.save_data.use_mouse:
		input = MouseHandler.new()
		focus()
	else:
		input = KeyboardHandler.new()
	add_child(input)
	
	var timer :Timer = $Timer
	var timer2 :Timer = $Timer2
	if Global.save_data.auto_shoot:
		timer.start()
		timer.connect("timeout", $bullet, 'SpawnBullet')
		timer2.start()
		timer2.connect("timeout", $bullet2, 'SpawnBullet')
	
func _hit() -> void:
	input.pause()
	hitSFX.play()
	emit_signal('die')

func unfocus() -> void:
	animation.play_backwards("focus")
	create_tween().tween_property(focus_layer, 'modulate', Color.transparent, .15)
	
func focus() -> void:
	animation.play("focus")
	create_tween().tween_property(focus_layer, 'modulate', Color.white, .15)

func bomb() -> void:
	if bombs:
		bombs -= 1
		collision_layer = 0
		graze.collision_layer = 0
		if Global.save_data.auto_shoot:
			tree.call_group('player_bullet', 'stop')
		
		var bomb_node :Node2D = bomb_scene.instance()
		bomb_node.connect('done', self, '_bomb_done')
		bomb_node.connect('done', input, '_bomb_done')
		Global.add_child(bomb_node)
		Global.emit_signal("bomb")

func _bomb_done():
	collision_layer = 4
	graze.collision_layer = 8
	if Global.save_data.auto_shoot:
		tree.call_group('player_bullet', 'start')
