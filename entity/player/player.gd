extends StaticBody2D
class_name Player

onready var focus : Sprite = $focus
onready var focus2 : Sprite = $focus2
onready var death_timer : Timer = $DeathTimer
onready var bomb_timer : Timer = $BombTimer
onready var graze : StaticBody2D = $graze
onready var tree := get_tree()
onready var bomb :int = Global.save.init_bomb
onready var tween := create_tween()

export (int) var speed := 527

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
	tree.paused = true
	death_timer.start()

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
		Global.emit_signal("bomb")
		collision_layer = 0
		graze.collision_layer = 0
		ItemManager.target = self
		tree.call_group('bullet', 'Flush')

func _update_bomb() -> void:
	bomb += 1
	Global.emit_signal("bomb")
	
func _on_DeathTimer_timeout():
	tree.paused = false
	
func _on_BombTimer_timeout():
	collision_layer = 4
	graze.collision_layer = 8
	tree.set_group('bullet', 'shooting', true)
