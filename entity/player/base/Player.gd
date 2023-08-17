extends CharacterBody2D
class_name Player

func _ready() -> void:
	if is_multiplayer_authority():
		Global.player1 = self
		return
	
	Global.player2 = self
	hitbox.queue_free()
	set_process_unhandled_input(false)
	
############## COLLISION
@onready var death_timer := $DeathTimer
@onready var hit_sfx := $HitSFX
@onready var tree := get_tree()
@export var sprite : Node2D
func _hit() -> void:
	hit_sfx.play()
	hitbox.set_deferred('disabled', true)
	Global.leveler.screen_effect.flash_red()
	death_timer.start()
	if not Global.player2:
		tree.paused = true
####################

var can_bomb := true
var bomb_count := 3
@onready var sentivity := Global.user_data.sentivity
@onready var toggle_move := Global.user_data.toggle_move
var can_move := false
const playground := Vector2(540.0, 852.0)
func _input(event:InputEvent) -> void:
	if toggle_move and event.is_action_pressed('drag'):
		can_move = not can_move
		return
	else:
		can_move = Input.is_action_pressed("drag")
	
	if (event is InputEventMouseMotion and can_move) or event is InputEventScreenDrag:
		global_position += event.relative * sentivity
		global_position.x = clamp(global_position.x, 0.0, playground.x)
		global_position.y = clamp(global_position.y, 0.0, playground.y)
		
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
func _on_death_timer_timeout():
	Global.leveler.screen_effect.hide()
	rpc("_sync_death")
	
	if Global.player2 and not Global.last_man_standing:
		Global.hud.player_died()
	else:
		Global.leveler.restart()
		
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
	
@onready var spawn_pos := position
@rpc("reliable", "call_local")
func _sync_revive() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	sprite.show()
	recover_timer.start()
	modulate = Color(Color.WHITE, .5)
	position = spawn_pos
	
	Global.last_man_standing = false
