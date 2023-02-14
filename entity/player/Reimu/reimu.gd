extends StaticBody2D
class_name Player

signal dying

onready var hitFx : Sprite = $hitFx
onready var hitSFX : AudioStreamPlayer = $hitFx/hitSfx

onready var graze : StaticBody2D = $graze
onready var graze_fx : Particles2D = $graze/grazeFX
onready var graze_timer : Timer = $graze/grazeFX/Timer

onready var focus_layer : Sprite = $focus
onready var death_tween :Tween = $hitFx/Tween

onready var tree := get_tree()
onready var user_setting :UserSetting = Global.user_setting

onready var sentivity := user_setting.sentivity
var moving := false

const bomb_impact_times := 4
var bomb_count := 1

func _set_bomb_count():
	bomb_count += 1

func _ready():
	Global.connect("bullet_graze", self, '_graze')
	Global.connect("bomb_finished", self, '_bomb_finished')
	
	if user_setting.invicible:
		$hitbox.queue_free()
		hitFx.queue_free()
	
	remove_child(hitFx)
	graze_timer.connect("timeout", graze_fx, 'set_emitting', [false])
	death_tween.interpolate_property(hitFx, 'scale', Vector2.ONE, Vector2(.01, .01), Global.user_setting.assit_duration)
	death_tween.connect("tween_all_completed", Global, "emit_signal", ["player_died"])
	
	Global.player = self
	
func _unhandled_input(event:InputEvent):
	if event.is_action_pressed('drag'):
		moving = true
		create_tween().tween_property(focus_layer, 'modulate', Color.white, .25)
		return
	elif event.is_action_released('drag'):
		moving = false
		create_tween().tween_property(focus_layer, 'modulate', Color.transparent, .25)
		return
	
	if event is InputEventMouseMotion and moving:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, 646.0)
		position.y = clamp(position.y, 0.0, 904.0)

func _hit():
	if tree.paused:
		return
	
	set_process_unhandled_input(false)
	emit_signal("dying")
	Global.level.screenfx.flash_red()
	
	add_child(hitFx)
	hitSFX.play()
	death_tween.start()
	
	tree.paused = true
	
func _graze():
	graze_fx.emitting = true
	graze_timer.start()

func bomb():
	if not bomb_count:
		return
		
	if not user_setting.infinity_bomb:
		bomb_count -= 1
		Global.level.hud.update_bomb()
		
	Global.level.screenfx.hide()
	death_tween.stop_all()
	death_tween.reset_all()
	remove_child(hitFx)
	
	collision_layer = 0
	graze.collision_layer = 0
	modulate = Color(1.0, 1.0, 1.0, .5)
	tree.call_group('player_bullet', 'stop')
	
	var bomb_node = preload("res://entity/player/Reimu/FantasySeal.cs").new()
	add_child(bomb_node)

	tree.paused = false
	set_process_unhandled_input(true)
	
func _bomb_finished():
	collision_layer = 4
	graze.collision_layer = 8
	modulate = Color.white
	tree.call_group('player_bullet', 'start')
