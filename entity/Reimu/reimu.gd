extends StaticBody2D
class_name Player

@onready var graze : StaticBody2D = $graze
@onready var focus_layer : AnimationPlayer = $focus/AnimationPlayer
@onready var death_timer : Timer = $DeathTimer
@onready var orb_animator : AnimationPlayer = $orbAnimator
@onready var orb_bullet : Node2D = $bullet2

@onready var tree := get_tree()
@onready var user_data :UserData = Global.user_data

@onready var sentivity := user_data.sentivity
var moving := false
var bomb_scene := preload("res://entity/Reimu/FantasySeal.tscn")
var bomb_count := 1
@export var bullet_timer : Array

var can_shoot := true : set = _set_shooting
func _set_shooting(value:bool) -> void:
	can_shoot = value
	if value:
		orb_animator.speed_scale = 1.0
		for node in bullet_timer:
			node.start()
			
	else:
		orb_animator.speed_scale = .25
		for node in bullet_timer:
			node.stop()

func _on_death_timer_timeout() -> void:
	Global.leveler.restart()

func _ready() -> void:
	death_timer.timeout.connect(Callable(self, '_on_death_timer_timeout'))
	Global.bomb_impact.connect(Callable(self,'_bomb_impact'))
	orb_animator.play("spin")
	
	var nodes := []
	for path in bullet_timer:
		nodes.append(get_node(path))
	bullet_timer = nodes
	
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

func _hit() -> void:
	if tree.paused:
		return
	
	set_process_unhandled_input(false)
	Global.leveler.screenfx.flash_red()
	death_timer.start()

	tree.paused = true

func bomb() -> void:
	if not bomb_count:
		return
		
	Global.leveler.hud._update_bomb()
	Global.leveler.screenfx.hide()
	death_timer.stop()
	
	collision_layer = 0
	graze.collision_layer = 0
	modulate = Color(0.61960786581039, 0.61960786581039, 0.61960786581039)
	if can_shoot:
		for timer in bullet_timer:
			timer.stop()
	
	add_child(bomb_scene.instantiate())
	tree.paused = false
	set_process_unhandled_input(true)
	
func _bomb_impact() -> void:
	collision_layer = 4
	graze.collision_layer = 8
	modulate = Color.WHITE
