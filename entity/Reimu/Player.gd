extends StaticBody2D
class_name Player

func _ready() -> void:
	Global.bomb_finished.connect(_bomb_finished)
	Global.player = self
	ItemManager.target = self
	Global.can_player_shoot.emit(true)

@export var death_timer : Timer
func _hit() -> void:
	if is_multiplayer_authority():
		return
	
	set_process_unhandled_input(false)
	VisualEffect.flash_red()
	death_timer.start()

@export var hitbox : CollisionShape2D
func _bomb_finished() -> void:
	hitbox.set_deferred('disabled', false)
	can_bomb = true
	
var is_left := false
var moving := false
@onready var sentivity := Global.user_data.sentivity
func _unhandled_input(event:InputEvent) -> void:
	moving = event.is_action_pressed('drag')
	
	if (event is InputEventMouseMotion and moving) or event is InputEventScreenDrag:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, global.playground.x)
		position.y = clamp(position.y, 0.0, global.playground.y)
		
		change_direction(event.relative.angle())
		if is_multiplayer_authority():
			rpc('_update_position')
		
@export var sprite : AnimatedSprite2D
func change_direction(angle:float):
		if angle <= PI / 2 and angle < -PI/2 and is_left:
			#Right
			sprite.play()
			is_left = false
		elif not is_left:
			sprite.play()
			is_left = true

@rpc
func _update_position(pos:Vector2) -> void:
	create_tween().tween_property(self, 'global_position', pos, .1)
	change_direction(pos.angle())

var can_bomb := false
var bomb_count := 1
@export var bomb_scene : PackedScene
func bomb() -> void:
	if not bomb_count and can_bomb:
		return
	
	bomb_count -= 1
	can_bomb = false
	VisualEffect.hide()
	death_timer.stop()
	set_process_unhandled_input(true)
	hitbox.set_deferred("disabled", true)

	var node := bomb_scene.instantiate()
	VisualEffect.current_scene.add_child(node)
