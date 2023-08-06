extends CharacterBody2D
class_name Player

func _ready() -> void:
	if not is_multiplayer_authority():
		hitbox.queue_free()
		set_process_unhandled_input(false)
	
############## COLLISION
@onready var death_timer := $DeathTimer
@onready var hit_sfx := $HitSFX
func _hit() -> void:
	hit_sfx.play()
	hitbox.set_deferred('disabled', true)
	VisualEffect.flash_red()
	death_timer.start()
####################

var can_bomb := true
var bomb_count := 3
@onready var sentivity := Global.user_data.sentivity
@onready var toggle_move := Global.user_data.toggle_move
var can_move := false
func _input(event:InputEvent) -> void:
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
			rpc('_update_position', global_position)
		
	elif Input.is_action_pressed("bomb") or event is InputEventPanGesture:
		if not bomb_count or not can_bomb:
			return
		
		bomb_count -= 1
		can_bomb = false
		if Global.hud:
			Global.hud.update_bomb(bomb_count)
		
		if is_multiplayer_authority():
			hitbox.set_deferred("disabled", true)
			
		kaboom.emit(0)
		rpc('bomb_go_off', Time.get_ticks_msec())

@rpc
func _update_position(pos:Vector2) -> void:
	global_position = pos

signal kaboom
@rpc("reliable")
func bomb_go_off(host_time:int) -> void:
	kaboom.emit((host_time - int(Global.get_host_time()) / 1000))
	
@export var hitbox : CollisionShape2D
func _bomb_finished() -> void:
	if is_multiplayer_authority():
		hitbox.set_deferred('disabled', false)
	can_bomb = true
#####################
@onready var death_sfx := $DeathSFX
@onready var death_fx := $explosion
@export var sprite : AnimatedSprite2D
func _on_death_timer_timeout():
	VisualEffect.hide()
	rpc("_sync_death")
	
	if Global.player2 and not Global.last_man_standing:
		Global.hud.player_died()
	else:
		Global.restart_scene()
		
@rpc("reliable", "call_local")
func _sync_death() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	death_fx.emitting = true
	death_sfx.play()
	sprite.hide()
	Global.last_man_standing = true

@onready var revive_fx := $ReviveSFX
func _on_recover_timer_timeout():
	revive_fx.play()
	hitbox.set_deferred('disabled', false)
	modulate = Color.WHITE

@onready var recover_timer := $RecoverTimer
func revive() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED or not Global.player2:
		return
	rpc("_sync_revive")
	
@rpc("reliable", "call_local")
func _sync_revive() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	sprite.show()
	recover_timer.start()
	modulate = Color(Color.WHITE, .5)
	
	Global.last_man_standing = false
	
