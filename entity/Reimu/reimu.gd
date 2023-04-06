extends StaticBody2D
class_name Player

@onready var graze : StaticBody2D = $graze
@onready var death_timer : Timer = $DeathTimer
@onready var focus : Sprite2D = $focus
@onready var focus_layer : AnimationPlayer = $focus/AnimationPlayer
@onready var bomb_timer : Timer = $BombTimer
@onready var hitbox : CollisionShape2D = $CollisionShape2D

@onready var tree := get_tree()
@onready var user_data :UserData = Global.user_data

@onready var sentivity := user_data.sentivity
var moving := false
var bomb_queue := 0
var bomb_count := 1

func _hit() -> void:
	if tree.paused:
		return
	
	set_process_unhandled_input(false)
	ScreenEffect.flash_red()
	death_timer.start()
	tree.paused = true

func _ready() -> void:
	#add_child(Global.score.shoot_type.instantiate())
	Global.can_player_shoot.emit(true)
	Global.player = self
	ItemManager.target = self
	set_process_unhandled_input(false)
	global_position = Vector2(302, 1100)
	
	var tween := create_tween()
	tween.tween_property(self, 'position', Vector2(302, 700), .5)
	tween.finished.connect(Callable(self, 'set_process_unhandled_input').bind(true))
	
func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed('drag'):
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

	bomb_count -= 1
	Global.leveler.hud._update_bomb()
	ScreenEffect.hide()
	death_timer.stop()
	tree.paused = false
	set_process_unhandled_input(true)
	hitbox.set_deferred("disabled", false)
	
	bomb_timer.start()
	_on_bomb_spawner_timeout()
	bomb_queue += 3

func _on_bomb_spawner_timeout() -> void:
	bomb_queue -= 1
	if not bomb_queue:
		bomb_timer.stop()
		hitbox.set_deferred("disabled", true)
	
	"""var node : Node2D = bomb_scene.instantiate()
	node.global_position = global_position
	death_timer.add_child(node)"""
