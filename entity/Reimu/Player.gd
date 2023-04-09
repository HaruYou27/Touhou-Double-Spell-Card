extends StaticBody2D
class_name Player

@onready var death_timer : Timer = $DeathTimer
@onready var hitbox : CollisionShape2D = $Hitbox

@onready var tree := get_tree()
@onready var user_data :UserData = Global.user_data

@onready var sentivity := user_data.sentivity

var moving := false
var can_bomb := false
var bomb_count := 1

const bomb_scene := preload("res://entity/Reimu/kishin-orb.tscn")

func _hit() -> void:
	if tree.paused:
		return
	
	set_process_unhandled_input(false)
	VisualEffect.flash_red()
	death_timer.start()
	tree.paused = true

func _ready() -> void:
	Global.bomb_finished.connect(_bomb_finished)
	add_child(Global.score.shoot_type.instantiate())
	Global.player = self
	ItemManager.target = self
	set_process_unhandled_input(false)
	
	var tween := create_tween()
	tween.tween_property(self, 'position', Vector2(540, 1425), .5)
	tween.finished.connect(_already)
	
func _bomb_finished() -> void:
	hitbox.set_deferred('disabled', false)
	can_bomb = true
	
func _already() -> void:
	set_process_unhandled_input(true)
	Global.can_player_shoot.emit(true)
	can_bomb = true
	
func _unhandled_input(event:InputEvent) -> void:
	moving = event.is_action_pressed('drag')
	
	if event is InputEventMouseMotion and moving:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, global.playground.x)
		position.y = clamp(position.y, 0.0, global.playground.y)

func bomb() -> void:
	if not bomb_count and can_bomb:
		return
	
	bomb_count -= 1
	can_bomb = false
	VisualEffect.hide()
	death_timer.stop()
	tree.paused = false
	set_process_unhandled_input(true)
	hitbox.set_deferred("disabled", true)

	var node := bomb_scene.instantiate()
	VisualEffect.current_scene.add_child(node)
