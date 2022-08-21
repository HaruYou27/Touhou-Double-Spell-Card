extends Node2D
class_name Player

var cooldown := 0

onready var bullet : Node2D = $bullet
onready var bullet_focus : Node2D = $bulletFocus
onready var statellite : Node2D = $bulletFocus
onready var statellite_focus : Node2D = $bulletFocus

export (int) var speed := 527

func _ready() -> void:
	if Global.save.input_method == save_data.input.KEYBOARD:
		add_child(preload("res://autoload/controls/keyboard.gd").new())

func _physics_process(_delta):
	if Input.is_action_just_pressed("focus"):
		bullet_focus.shoting = true;
		statellite_focus.shoting = true;
		bullet.shoting = false;
		statellite.shoting = false;
	elif Input.is_action_just_released("focus"):
		bullet.shoting = true
		statellite.shoting = true
		bullet_focus.shoting = false
		statellite_focus.shoting = false
