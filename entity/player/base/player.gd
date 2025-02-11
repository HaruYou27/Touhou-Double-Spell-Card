extends Player
	
@onready var death_timer: Timer = $explosion/DeathTimer
@onready var tree := get_tree()
@export var sprite : Node2D
@onready var layer_physics := collision_layer
func hit() -> void:
	if not (is_alive):
		return
	is_alive = false
	SoundEffect.player_hit()
	collision_layer = 0
	ScreenVFX.flash_red()
	death_timer.start()
	if GlobalItem:
		tree.paused = true

func _enter_tree() -> void:
	set_sentivity(Global.user_data.sentivity)

var can_bomb := true
func _on_bomb() -> void:
	if not (GlobalScore.use_bomb() and can_bomb):
		return

	can_bomb = false
	sprite.self_modulate = Color(1.0,1.0,1.0,0.5)
	collision_layer = 0
	
	_bomb_away.rpc()

var tween: Tween
@rpc("unreliable_ordered", "call_remote", "authority")
func _update_position(pos:Vector2) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", pos, 0.03)

@rpc("reliable", "call_remote", "authority")
func _bomb_away() -> void:
	bomb.emit()
	
func bomb_finished(_nm) -> void:
	collision_layer = layer_physics
	can_bomb = true
	sprite.self_modulate = Color.WHITE

@onready var death_sfx: AudioStreamPlayer = $DeathSFX
@onready var death_fx: GPUParticles2D = $explosion
@onready var revive_timer: Timer = $ReviveTimer
func _on_death_timer_timeout():
	ScreenVFX.hide()
	is_alive = false
	sync_death()
	
	rpc("sync_death")
	
	if GlobalItem.is_offline():
		Global.leveler.pause.pressed.emit()
	else:
		if Global.last_man_standing:
			Global.leveler.animator.stop()
		else:
			revive_timer.start()
		
@rpc("reliable", "authority")
func sync_death() -> void:
	set_process_input(false)
	process_mode = Node.PROCESS_MODE_DISABLED
	sprite.hide()
	
	death_fx.emitting = true
	death_sfx.play()
	
	Global.last_man_standing = true

@onready var revive_fx: AudioStreamPlayer = $ReviveSFX
func _on_recover_timer_timeout():
	revive_fx.play()
	collision_layer = layer_physics
	sprite.self_modulate = Color.WHITE

var is_alive := true
func revive() -> void:
	if is_alive:
		return
		
	is_alive = true
	sync_revive()
	rpc("sync_revive")

@onready var recover_timer: Timer = $RecoverTimer
@onready var spawn_pos := position
@rpc("reliable", "authority")
func sync_revive() -> void:
	#print_debug('revive')
	process_mode = Node.PROCESS_MODE_INHERIT
	set_process_input(true)
	sprite.show()
	
	recover_timer.start()
	sprite.self_modulate = Color(Color.WHITE, .5)
	position = spawn_pos

	Global.last_man_standing = false

func _on_position_changed() -> void:
	_update_position.rpc(global_position)
