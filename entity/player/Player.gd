extends StaticBody2D
class_name Player

signal open_fire
signal stop_fire
@onready var animator := $AnimationPlayer
func _ready() -> void:
	if not is_multiplayer_authority():
		set_process_unhandled_input(false)
		hitbox.queue_free()
	animator.play("spawn")

############## COLLISION
@onready var death_timer := $DeathTimer
func _hit() -> void:
	set_process_unhandled_input(false)
	VisualEffect.flash_red()
	death_timer.start()
	stop_fire.emit()
####################

##################### MOVEMENT
@onready var sentivity := Global.user_data.sentivity
func _unhandled_input(event:InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.is_action_pressed("drag")) or event is InputEventScreenDrag:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, global.playground.x)
		position.y = clamp(position.y, 0.0, global.playground.y)
		
		if is_multiplayer_authority():
			rpc('_update_position')

@rpc
func _update_position(pos:Vector2) -> void:
	create_tween().tween_property(self, 'global_position', pos, .1)
#############################


############### BOMBING
var can_bomb := false
var bomb_count := 1
signal kaboom
func bomb() -> void:
	if not bomb_count and can_bomb:
		return
	
	bomb_count -= 1
	can_bomb = false
	stop_fire.emit()
	VisualEffect.hide()
	death_timer.stop()
	Global.hud.update_bomb()
	
	kaboom.emit()

	if is_multiplayer_authority():
		set_process_unhandled_input(true)
		hitbox.hide()
		hitbox.set_deferred("disabled", true)
	
@export var hitbox : CollisionShape2D
func _bomb_finished() -> void:
	if is_multiplayer_authority():
		hitbox.show()
		hitbox.set_deferred('disabled', false)
	can_bomb = true
	open_fire.emit()
#####################

func _on_animation_player_animation_finished(anim_name):
	open_fire.emit()
