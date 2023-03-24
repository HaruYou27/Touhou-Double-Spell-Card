extends StaticBody2D
class_name Player

signal set_shooting(value:bool)

@onready var graze : StaticBody2D = $graze
@onready var death_timer : Timer = $DeathTimer
@onready var focus : Sprite2D = $focus
@onready var focus_layer : AnimationPlayer = $focus/AnimationPlayer

@onready var tree := get_tree()
@onready var user_data :UserData = Global.user_data

@onready var sentivity := user_data.sentivity
var moving := false
var bomb_scene := preload("res://entity/Reimu/FantasySeal.tscn")
var bomb_count := 1

var can_shoot := true : set = _set_shooting
func _set_shooting(value:bool) -> void:
	can_shoot = value
	set_shooting.emit(value)

func _hit() -> void:
	if tree.paused:
		return
	
	set_process_unhandled_input(false)
	Global.leveler.screenfx.flash_red()
	death_timer.start()

	tree.paused = true

func _ready() -> void:
	Global.player = self
	Global.bomb_impact.connect(Callable(self,'_bomb_impact'))
	
	set_process_unhandled_input(false)
	global_position = Vector2(302, 1100)
	var tween := create_tween()
	tween.tween_property(self, 'position', Vector2(302, 700), .5)
	tween.finished.connect(Callable(self, 'ready'))
	
func ready() -> void:
	set_process_unhandled_input(true)
	
func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_released("bomb"):
		bomb()
	elif event.is_action_pressed('drag'):
		moving = true
		focus_layer.play("show")
		return
	elif event.is_action_released('drag'):
		moving = false
		focus_layer.play_backwards("show")
		return
	
	if event is InputEventMouseMotion and moving:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, global.playground.x)
		position.y = clamp(position.y, 0.0, global.playground.y)

func bomb() -> void:
	if not bomb_count:
		return
		
	Global.leveler.hud._update_bomb()
	Global.screenfx.hide()
	death_timer.stop()
	
	process_mode = Node.PROCESS_MODE_DISABLED
	graze.process_mode = Node.PROCESS_MODE_DISABLED
	set_shooting.emit(false)
	
	add_child(bomb_scene.instantiate())
	tree.paused = false
	set_process_unhandled_input(true)
	
func _bomb_impact() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	graze.process_mode = Node.PROCESS_MODE_INHERIT
	if can_shoot:
		set_shooting.emit(true)
