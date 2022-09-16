extends StaticBody2D
class_name Player

onready var hit : Sprite = $hit
onready var hitSFX : AudioStreamPlayer = $hitSFX
onready var focus_layer : Sprite = $focus
onready var graze : StaticBody2D = $graze
onready var animation :AnimationPlayer = $AnimationPlayer

onready var level := get_parent()
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
	
	if Global.save_data.auto_shoot:
		tree.set_group('player_bullet', 'shooting', true)
	remove_child(hit)
	
func _hit() -> void:
	input.pause()
	tree.paused = true
	
	hitSFX.play()
	add_child(hit)
	hit.scale = Vector2.ONE
	level.flash_red()
	
	var tween := create_tween()
	tween.tween_property(hit, 'scale', Vector2(0.01, 0.01), death_time)
	tween.connect("finished", level, '_on_Restart_pressed')

func unfocus() -> void:
	animation.play_backwards("focus")
	create_tween().tween_property(focus_layer, 'modulate', Color.transparent, 0.15)
	
func focus() -> void:
	animation.play("focus")
	create_tween().tween_property(focus_layer, 'modulate', Color.white, 0.15)

func bomb() -> void:
	remove_child(hit)
	
	if bombs:
		bombs -= 1
		collision_layer = 0
		graze.collision_layer = 0
		if Global.save_data.auto_shoot:
			tree.set_group('player_bullet', 'shooting', false)
		
		var bomb_node :Node2D = bomb_scene.instance()
		bomb_node.connect('done', self, '_bomb_done')
		bomb_node.connect('done', input, '_bomb_done')
		level.add_child(bomb_node)
		Global.emit_signal("bomb")

func _bomb_done():
	collision_layer = 4
	graze.collision_layer = 8
	if Global.save_data.auto_shoot:
		tree.set_group('player_bullet', 'shooting', true)
