extends StaticBody2D
class_name Player

signal deathdoor
signal update_score(value)

onready var bullet : Node2D = $bullet
onready var bullet_focus : Node2D = $bulletFocus
onready var statellite : Node2D = $statellite
onready var statellite_focus : Node2D = $statelliteFocus
onready var focus :Sprite = $focus
onready var focus2 :Sprite = $focus2

export (int) var speed := 527

func _ready() -> void:
	Global.player = self
	if Global.save.input_method == saveData.input.KEYBOARD:
		add_child(preload("res://autoload/controls/keyboard.gd").new())

func _hit() -> void:
	emit_signal('deathdoor')

func _physics_process(_delta):
	if Input.is_action_just_pressed("focus"):
		bullet_focus.shoting = true;
		statellite_focus.shoting = true;
		bullet.shoting = false;
		statellite.shoting = false;
		focus.visible = true
		focus2.visible = true
	elif Input.is_action_just_released("focus"):
		bullet.shoting = true
		statellite.shoting = true
		bullet_focus.shoting = false
		statellite_focus.shoting = false
		focus.visible = false
		focus2.visible = false
