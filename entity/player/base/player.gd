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
	
	set_process_input(false)
	process_mode = Node.PROCESS_MODE_DISABLED
	sprite.hide()
	death_fx.emitting = true
	death_sfx.play()
	
	if GlobalItem.is_offline():
		Global.leveler.pause.pressed.emit()
	else:
		if Global.last_man_standing:
			Global.leveler.animator.stop()
		else:
			revive_timer.start()

@onready var revive_fx: AudioStreamPlayer = $ReviveSFX
func _on_recover_timer_timeout():
	revive_fx.play()
	collision_layer = layer_physics
	sprite.self_modulate = Color.WHITE

@onready var recover_timer: Timer = $RecoverTimer
@onready var spawn_pos := position
var is_alive := true
func revive() -> void:
	if is_alive:
		return
		
	is_alive = true
	process_mode = Node.PROCESS_MODE_INHERIT
	set_process_input(true)
	sprite.show()
	
	recover_timer.start()
	sprite.self_modulate = Color(Color.WHITE, .5)
	position = spawn_pos