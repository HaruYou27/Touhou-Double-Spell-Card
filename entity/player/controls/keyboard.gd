extends Node
class_name KeyboardHandler

onready var player :Node2D = get_parent()
onready var tree := get_tree()

var focus := false

func _unhandled_input(event):
	if event.is_action_pressed("bomb"):
		player.bomb()
		if tree.paused:
			set_physics_process(true)
			set_process_input(false)
			set_process_unhandled_input(false)
			tree.paused = false
			
func pause() -> void:
	set_physics_process(false)
	set_process_input(false)

func _bomb_done() -> void:
	set_process_input(not Global.save_data.auto_shoot)
	set_process_unhandled_input(true)
		
func _ready():
	set_process_input(not Global.save_data.auto_shoot)

func _physics_process(delta:float) -> void:
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	var velocity := Vector2(x, y).normalized()
	
	if Input.is_action_pressed('focus'):
		velocity /= 6
		if not focus:
			focus = true
			player.focus()
	elif focus:
		focus = false
		player.unfocus()
	
	player.position += velocity * delta * 575
	player.position.x = clamp(player.position.x, 0.0, Global.playground.x)
	player.position.y = clamp(player.position.y, 0.0, Global.playground.y)

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		tree.call_group('player_bullet', 'start')
	elif event.is_action_released("shoot"):
		tree.call_group('player_bullet', 'stop')
