extends Node

onready var player :Node2D = get_parent()
onready var autoshoot := Global.save.auto_shoot
onready var tree := get_tree()

var focus := 1.0

func _unhandled_input(event):
	if event.is_action_pressed("focus"):
		focus = 0.25
		player.focus()
	elif event.is_action_released("focus"):
		focus = 1
		player.unfocus()

func _physics_process(delta:float) -> void:
	if not autoshoot:
		if Input.is_action_just_pressed("shoot"):
			tree.set_group('player_bullet', 'shooting', true)
		elif Input.is_action_just_released("shoot"):
			tree.set_group('player_bullet', 'shooting', false)
	
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	var velocity := Vector2(x, y).normalized()
	
	player.position += velocity * delta * 372 * focus
	player.position.x = clamp(player.position.x, 0.0, 646.0)
	player.position.y = clamp(player.position.y, 0.0, 904.0)

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("bomb"):
		player.bomb()
		if tree.paused:
			tree.paused = false
