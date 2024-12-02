extends StaticBody2D
class_name Player
## Mostly movement code.

func _ready() -> void:
	if is_multiplayer_authority():
		Global.player1 = self
		return
	
	Global.player2 = self
	set_process_unhandled_input(false)
	collision_layer = 0

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

var can_bomb := true
var bomb_count := 3
@onready var sentivity := Global.user_data.sentivity
var can_move := false
func _input(event:InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.is_action_pressed("drag")):
		move(event)

	elif event is InputEventScreenDrag:
		move(event)
		if event.index > 1:
			bomb()
		
	elif event.is_action_pressed("bomb"):
		bomb()

## How the player move
func move(event:InputEvent) -> void:
	global_position += event.relative * sentivity
	global_position.x = clampf(global_position.x, 0.0, 540.0)
	global_position.y = clampf(global_position.y, 0.0, 960.0)
	
	if is_multiplayer_authority():
		rpc('_update_position', global_position)

func bomb() -> void:
	if not (bomb_count and can_bomb):
		return
		
	bomb_count -= 1
	can_bomb = false
	Global.hud.update_bomb(bomb_count)
	
	if is_multiplayer_authority():
		hitbox.set_deferred("disabled", true)
		
	kaboom.emit(0)
	rpc('bomb_go_off', Time.get_ticks_msec())

var tween: Tween
@rpc("unreliable_ordered", "call_remote", "authority")
func _update_position(pos:Vector2) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pos, 0.03)

signal kaboom
@rpc("reliable", "call_remote", "authority")
func bomb_go_off(host_time:int) -> void:
	kaboom.emit((host_time - int(Global.get_host_time()) / 1000))
	
@export var hitbox : CollisionShape2D
func _bomb_finished() -> void:
	if is_multiplayer_authority():
		hitbox.set_deferred('disabled', false)
	can_bomb = true

@onready var death_sfx := $DeathSFX
@onready var death_fx := $explosion
func _on_death_timer_timeout():
	Global.leveler.screen_effect.hide()
	rpc("_sync_death")
	
	if Global.player2 and not Global.last_man_standing:
		Global.hud.player_died()
	else:
		Global.leveler.pause.pressed.emit()
		
@rpc("reliable", "call_local", "authority")
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
@rpc("reliable", "call_local", "authority")
func _sync_revive() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	sprite.show()
	recover_timer.start()
	modulate = Color(Color.WHITE, .5)
	position = spawn_pos
	
	Global.last_man_standing = false
