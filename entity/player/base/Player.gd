extends StaticBody2D
class_name Player


func _ready() -> void:
	if not is_multiplayer_authority():
		hitbox.queue_free()
		Global.player2 = self
	else:
		Global.player1 = self
		kaboom.connect(Global.hud._update_bomb)
		
############## COLLISION
@onready var death_timer := $DeathTimer
func _hit() -> void:
	hitbox.set_deferred('disabled', true)
	VisualEffect.flash_red()
	death_timer.start()
####################

var can_bomb := false
var bomb_count := 3
@onready var sentivity := Global.user_data.sentivity
@onready var toggle_move := Global.user_data.toggle_move
var can_move := false
func _unhandled_input(event:InputEvent) -> void:
	if toggle_move and event.is_action_pressed('drag'):
		can_move = not can_move
		return
	else:
		can_move = Input.is_action_pressed("drag")
	
	if (event is InputEventMouseMotion and can_move) or event is InputEventScreenDrag:
		global_position += event.relative * sentivity
		global_position.x = clamp(global_position.x, 0.0, global.playground.x)
		global_position.y = clamp(global_position.y, 0.0, global.playground.y)
		
		if is_multiplayer_authority():
			rpc('_update_position')
	elif event.is_action_pressed("bomb") or event is InputEventPanGesture:
		bomb()

@rpc
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
	modulate = Color(Color.WHITE, .5)
	Global.hud.player_died()
	recover_timer.start()
	VisualEffect.hide()

func bomb():
	if not bomb_count and can_bomb:
			return
		
	bomb_count -= 1
	can_bomb = false
	VisualEffect.hide()
	death_timer.stop()
	
	hitbox.hide()
	hitbox.set_deferred("disabled", true)
		
	kaboom.emit(0)
	rpc('bomb_go_off', Time.get_ticks_msec())
