extends StaticBody2D
class_name Player

onready var hitFx : Sprite = $hitFx
onready var hitSFX : AudioStreamPlayer = $hitFx/hitSfx

onready var graze : StaticBody2D = $graze
onready var graze_fx : Particles2D = $graze/grazeFX
onready var graze_timer : Timer = $graze/grazeFX/Timer

onready var focus_layer : Sprite = $focus
onready var death_tween :Tween = $hitFx/Tween

onready var tree := get_tree()
onready var user_data :UserData = Global.user_data

onready var sentivity := user_data.sentivity
var moving := false

export (PackedScene) var bomb_scene
var bomb_count := 1

func _ready():
	Global.connect("bullet_graze", self, '_graze')
	Global.connect("bomb_impact", self, '_bomb_impact')
	
	remove_child(hitFx)
	graze_timer.connect("timeout", graze_fx, 'set_emitting', [false])
	death_tween.interpolate_property(hitFx, 'scale', Vector2.ONE, Vector2(.01, .01), Global.death_timer)
	death_tween.call_deferred('connect', 'tween_all_completed', Global.leveler, 'restart')
	
	Global.player = self
	
func _unhandled_input(event:InputEvent):
	if event.is_action_released("bomb"):
		bomb()
	elif event.is_action_pressed('drag'):
		moving = true
		create_tween().tween_property(focus_layer, 'modulate', Color.white, .25)
		return
	elif event.is_action_released('drag'):
		moving = false
		create_tween().tween_property(focus_layer, 'modulate', Color.transparent, .25)
		return
	
	if event is InputEventMouseMotion and moving:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, 604.0)
		position.y = clamp(position.y, 0.0, 906.0)

func _hit():
	if tree.paused:
		return
	
	set_process_unhandled_input(false)
	Global.levelr.screenfx.flash_red()
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
		
	Global.leveler.screenfx.hide()
	death_tween.stop_all()
	death_tween.reset_all()
	remove_child(hitFx)
	
	collision_layer = 0
	graze.collision_layer = 0
	modulate = Color(1.0, 1.0, 1.0, .5)
	tree.call_group('player_bullet', 'stop')
	
	add_child(bomb_scene.instance())

	tree.paused = false
	set_process_unhandled_input(true)
	
func _bomb_impact():
	collision_layer = 4
	graze.collision_layer = 8
	modulate = Color.white
	tree.call_group('player_bullet', 'start')
