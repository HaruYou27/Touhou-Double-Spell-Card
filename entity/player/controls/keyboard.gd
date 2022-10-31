extends Node
class_name KeyboardHandler

onready var player :Node2D
onready var tree := get_tree()
onready var manual_shoot := not Global.save_data.auto_shoot

var speed := 575

func _init(node) -> void:
	player = node

func _unhandled_input(event) -> void:
	if event.is_action_pressed("bomb"):
		player.bomb()
		set_physics_process(true)
		set_process_input(false)
		set_process_unhandled_input(false)
		
		player.unfocus()
		speed = 575
	elif event.is_action_pressed('focus'):
		player.focus()
		speed = 96
	elif event.is_action_released('focus'):
		player.unfocus()
		speed = 575
			
func pause() -> void:
	set_physics_process(false)
	set_process_input(false)
	pause_mode = Node.PAUSE_MODE_PROCESS

func _bomb_done() -> void:
	set_process_input(manual_shoot)
	set_process_unhandled_input(true)
	pause_mode = Node.PAUSE_MODE_INHERIT
	
func _ready():
	set_process_input(manual_shoot)

func _physics_process(delta:float) -> void:
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	var velocity := Vector2(x, y).normalized()
	
	player.position += velocity * delta * speed

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		tree.call_group('player_bullet', 'start')
	elif event.is_action_released("shoot"):
		tree.call_group('player_bullet', 'stop')
