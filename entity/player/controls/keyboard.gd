extends Node
class_name KeyboardInput

onready var player :Node2D = get_parent()
onready var tree := get_tree()
onready var speed_norm :int = Global.user_setting.player_velocity
onready var speed_focus :int = Global.user_setting

var speed := speed_norm

func _ready():
	Global.connect("bomb_finished", self, "_bomb_finished")

func _unhandled_input(event):
	if event.is_action_pressed("bomb"):
		player.bomb()
		speed = 575

		set_physics_process(true)
		set_process_unhandled_input(false)
	elif event.is_action_pressed('focus'):
		player.focus = true
		speed = 96
	elif event.is_action_released('focus'):
		player.focus = false
		speed = 575

func pause():
	set_physics_process(false)
	pause_mode = Node.PAUSE_MODE_PROCESS

func _bomb_finished():
	set_process_unhandled_input(true)
	pause_mode = Node.PAUSE_MODE_INHERIT

func _physics_process(delta:float):
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	var velocity := Vector2(x, y).normalized()
	
	player.position += velocity * delta * speed
	player.position.x = clamp(player.position.x, 0.0, 646.0)
	player.position.y = clamp(player.position.y, 0.0, 904.0)
