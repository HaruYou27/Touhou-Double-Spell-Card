extends StaticBody2D
class_name Player

onready var hit : Sprite = $hit
onready var focus : Sprite = $focus
onready var graze : StaticBody2D = $graze
onready var tree := get_tree()
onready var bombs :int = Global.save.init_bomb
onready var tween := create_tween()
onready var death_time = Global.save.death_time

var input :Node

export (PackedScene) var bomb_scene

func _ready() -> void:
	Global.player = self
	if Global.save.input_method == saveData.input.KEYBOARD:
		input = preload("res://autoload/controls/keyboard.gd").new()
	elif Global.save.input_method == saveData.input.MOUSE:
		input = preload("res://autoload/controls/mouse.gd").new()
	else:
		input = preload("res://autoload/controls/touch.gd").new()
	add_child(input)
	tree.set_group('player_bullet', 'shooting', Global.save.auto_shoot)
	remove_child(hit)
	
func _hit() -> void:
	pass
	"""
	input.set_process_unhandled_input(false)
	input.set_physics_process(false)
	tree.paused = true
	add_child(hit)
	hit.scale = Vector2(1, 1)
	var tween := create_tween()
	tween.tween_property(hit, 'scale', Vector2(0.01, 0.01), death_time)
	tween.tween_callback(Global, 'emit_signal', ['die'])"""

func unfocus() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(focus, 'modulate', Color(1.0, 1.0, 1.0, 0.0), 0.15)
	
func focus() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(focus, 'modulate', Color(1.0, 1.0, 1.0, 1.0), 0.15)

func bomb() -> void:
	if bombs:
		bombs -= 1
		collision_layer = 0
		graze.collision_layer = 0
		tree.set_group('player_bullet', 'shooting', false)
		input.set_process_input(false)
		
		var bomb_node :Node2D = bomb_scene.instance()
		bomb_node.connect('done', self, '_bomb_done')
		Global.add_child(bomb_node)
		Global.emit_signal("bomb")

func _bomb_done():
	collision_layer = 4
	graze.collision_layer = 8
	tree.set_group('player_bullet', 'shooting', true)
	input.set_process_input(true)
