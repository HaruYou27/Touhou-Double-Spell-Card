extends StaticBody2D
class_name Player

func _ready() -> void:
	if not is_multiplayer_authority():
		set_process_unhandled_input(false)
		hitbox.queue_free()

############## COLLISION
@onready var death_timer := $DeathTimer
func _hit() -> void:
	set_process_unhandled_input(false)
	hitbox.set_deferred('disabled', false)
	VisualEffect.flash_red()
	death_timer.start()
####################

var can_bomb := false
var bomb_count := 3
@onready var sentivity := Global.user_data.sentivity
@onready var toggle_move := Global.user_data.toggle_move
var can_move := false
func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("drag"):
		if toggle_move:
			can_move = not can_move
		else:
			can_move = true
		return
	
	if (event is InputEventMouseMotion and can_move) or event is InputEventScreenDrag:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, global.playground.x)
		position.y = clamp(position.y, 0.0, global.playground.y)
		
		if is_multiplayer_authority():
			rpc('_update_position')
	elif event.is_action_pressed("bomb") or event is InputEventPanGesture:
		bomb()

func _update_position(pos:Vector2) -> void:
	create_tween().tween_property(self, 'global_position', pos, .1)

signal kaboom
@rpc("reliable")
func bomb_go_off(host_time:int) -> void:
	kaboom.emit((host_time - Global.get_host_time()) / 1000)
	
@export var hitbox : CollisionShape2D
func _bomb_finished() -> void:
	hitbox.show()
	hitbox.set_deferred('disabled', false)
	can_bomb = true
#####################

func _on_recover_timer_timeout():
	modulate = Color.WHITE
	hitbox.set_deferred('disabled', false)

@onready var recover_timer := $RecoverTimer
func _on_death_timer_timeout():
	set_process_unhandled_input(true)
	modulate = Color(Color.WHITE, .5)
	Global.hud.player_died()
	recover_timer.start()


func bomb():
	if not bomb_count and can_bomb:
			return
		
	bomb_count -= 1
	can_bomb = false
	VisualEffect.hide()
	death_timer.stop()
	Global.hud.update_bomb()
	
	set_process_unhandled_input(true)
	hitbox.hide()
	hitbox.set_deferred("disabled", true)
		
	kaboom.emit()
	rpc('bomb_go_off', Time.get_ticks_msec())
