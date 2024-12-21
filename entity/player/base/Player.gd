extends StaticBody2D
class_name Player
## Mostly movement code.

var bomb_count := 3
func _ready() -> void:
	if is_multiplayer_authority():
		Global.player1 = self
		return
	
	Global.player2 = self
	set_process_unhandled_input(false)
	collision_layer = 0
	Global.hud.update_bomb.call_deferred(bomb_count)
	
@onready var death_timer: Timer = $explosion/DeathTimer
@onready var tree := get_tree()
@export var sprite : Node2D
func hit() -> void:
	if not is_multiplayer_authority():
		return
	SoundEffect.press(true)
	hitbox.set_deferred('disabled', true)
	ScreenEffect.flash_red()
	death_timer.start()
	if not Global.player2:
		tree.paused = true

var can_bomb := true
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
	global_position.y = clampf(global_position.y, 0.0, 852.0)
	
	if is_multiplayer_authority():
		rpc('_update_position', global_position)

var tween_bomb: Tween
func bomb() -> bool:
	if not (bomb_count and can_bomb):
		return true
		
	bomb_count -= 1
	can_bomb = false
	Global.hud.update_bomb(bomb_count)
	tween_bomb = create_tween()
	tween_bomb.tween_property(sprite, "modulate", Color(1.0,1.0,1.0,0.5), 1.0)
	if is_multiplayer_authority():
		hitbox.set_deferred("disabled", true)
	
	rpc('bomb_go_off')
	return false

var tween: Tween
@rpc("unreliable_ordered", "call_remote", "authority")
func _update_position(pos:Vector2) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pos, 0.03)

signal kaboom
@rpc("reliable", "call_local", "authority")
func bomb_go_off() -> void:
	kaboom.emit()
	
@export var hitbox : CollisionShape2D
func bomb_finished() -> void:
	if is_multiplayer_authority():
		hitbox.set_deferred('disabled', false)
	can_bomb = true
	tween_bomb = create_tween()
	tween_bomb.tween_property(sprite, "modulate", Color.WHITE, 1.0)

@onready var death_sfx: AudioStreamPlayer = $explosion/DeathSFX
@onready var death_fx: GPUParticles2D = $explosion
@onready var revive_timer: Timer = $explosion/ReviveTimer
func _on_death_timer_timeout():
	ScreenEffect.hide()
	Global.hud.player_died()
	is_alive = false
	sync_death()
	
	rpc("sync_death")
	
	if Global.player2:
		if Global.last_man_standing:
			Global.leveler.animator.stop()
		else:
			revive_timer.start()
	else:
		Global.leveler.pause.pressed.emit()
		
@rpc("reliable", "authority")
func sync_death() -> void:
	set_process_unhandled_input(false)
	process_mode = Node.PROCESS_MODE_DISABLED
	sprite.hide()
	
	death_fx.emitting = true
	death_sfx.play()
	
	Global.last_man_standing = true

@onready var revive_fx := $ReviveSFX
func _on_recover_timer_timeout():
	revive_fx.play()
	hitbox.set_deferred('disabled', false)
	modulate = Color.WHITE

var is_alive := true
func revive() -> void:
	if is_alive:
		return
		
	is_alive = true
	sync_revive()
	rpc("sync_revive")

@onready var recover_timer := $RecoverTimer
@onready var spawn_pos := position
@rpc("reliable", "authority")
func sync_revive() -> void:
	#print_debug('revive')
	process_mode = Node.PROCESS_MODE_INHERIT
	set_process_unhandled_input(true)
	sprite.show()
	
	recover_timer.start()
	modulate = Color(Color.WHITE, .5)
	position = spawn_pos
	
	Global.last_man_standing = false
