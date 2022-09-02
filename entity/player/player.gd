extends StaticBody2D
class_name Player

onready var focus : Sprite = $focus
onready var focus2 : Sprite = $focus2
onready var death_timer : Timer = $DeathTimer
onready var graze : StaticBody2D = $graze
onready var tree := get_tree()
onready var bomb :int = Global.save.init_bomb
onready var tween := create_tween()

export (PackedScene) var bomb_scene

func _ready() -> void:
	Global.player = self
	BulletFx.target = self
	if Global.save.input_method == saveData.input.KEYBOARD:
		add_child(preload("res://autoload/controls/keyboard.gd").new())
	elif Global.save.input_method == saveData.input.MOUSE:
		add_child(preload("res://autoload/controls/mouse.gd").new())
	else:
		add_child(preload("res://autoload/controls/touch.gd").new())
		
func _hit() -> void:
	print('ouch')

func _unhandled_input(event) -> void:
	if event.is_action_pressed("focus"):
		focus()
	elif event.is_action_released("focus"):
		un_focus()
		
func un_focus() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(focus, 'modulate', Color(1.0, 1.0, 1.0, 0.0), 0.15)
	tween.parallel().tween_property(focus2, 'modulate', Color(1.0, 1.0, 1.0, 0.0), 0.15)
	
func focus() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(focus, 'modulate', Color(1.0, 1.0, 1.0, 1.0), 0.15)
	tween.parallel().tween_property(focus2, 'modulate', Color(1.0, 1.0, 1.0, 1.0), 0.15)

func bomb() -> void:
	if bomb:
		bomb -= 1
		collision_layer = 0
		graze.collision_layer = 0
		tree.set_group('player_bullet', 'shooting', false)
		death_timer.set_process_unhandled_input(false)
		
		var bomb_node :Node2D = bomb_scene.instance()
		bomb_node.connect('done', self, '_bomb_done')
		Global.add_child(bomb_node)
		Global.emit_signal("bomb")

func _update_bomb() -> void:
	bomb += 1
	Global.emit_signal("bomb")
	
func _on_DeathTimer_timeout():
	tree.paused = false
	
func _bomb_done():
	collision_layer = 4
	graze.collision_layer = 8
	tree.set_group('player_bullet', 'shooting', true)
	death_timer.set_process_unhandled_input(true)
