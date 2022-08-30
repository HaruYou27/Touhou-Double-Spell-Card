extends StaticBody2D
class_name Player

onready var statellite : Node2D = $statellite
onready var statellite_focus : Node2D = $statelliteFocus
onready var focus : Sprite = $focus
onready var focus2 : Sprite = $focus2
onready var timer : Timer = $DeathTimer
onready var graze : StaticBody2D = $graze
onready var tree := get_tree()
onready var bomb :int = Global.save.init_bomb

export (int) var speed := 527

func _ready() -> void:
	Global.player = self
	if Global.save.input_method == saveData.input.KEYBOARD:
		add_child(preload("res://autoload/controls/keyboard.gd").new())
	elif Global.save.input_method == saveData.input.MOUSE:
		add_child(preload("res://autoload/controls/mouse.gd").new())
	else:
		add_child(preload("res://autoload/controls/touch.gd").new())

func _hit() -> bool:
	tree.paused = true
	timer.start()
	tree.call_group('Bullet', 'Flush')
	return false

func _physics_process(_delta):
	if Input.is_action_just_pressed("focus"):
		statellite_focus.shooting = true;
		statellite.shooting = false;
		remove_child(focus)
		remove_child(focus2)
	elif Input.is_action_just_released("focus"):
		statellite.shooting = true
		statellite_focus.shooting = false
		add_child(focus)
		add_child(focus2)

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
	pass # Replace with function body.
	
func _on_BombTimer_timeout():
	collision_layer = 4
	graze.collision_layer = 8
	tree.set_group('bullet', 'shooting', true)
