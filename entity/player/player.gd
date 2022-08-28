extends StaticBody2D
class_name Player

signal update_score(value)

onready var statellite : Node2D = $statellite
onready var statellite_focus : Node2D = $statelliteFocus
onready var focus : Sprite = $focus
onready var focus2 : Sprite = $focus2
onready var timer : Timer = $DeathTimer
onready var graze : StaticBody2D = $graze
onready var tree := get_tree()
onready var physics_layer = collision_layer

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
		statellite_focus.shoting = true;
		statellite.shoting = false;
		focus.visible = true
		focus2.visible = true
	elif Input.is_action_just_released("focus"):
		statellite.shoting = true
		statellite_focus.shoting = false
		focus.visible = false
		focus2.visible = false

func bomb() -> void:
	collision_layer = 0
	graze.collision_layer = 0
		
func _on_DeathTimer_timeout():
	pass # Replace with function body.
