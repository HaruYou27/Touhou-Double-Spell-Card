extends StaticBody2D
class_name Player

onready var graze : StaticBody2D = $graze
onready var graze_fx : Particles2D = $graze/grazeFX
onready var graze_timer : Timer = $graze/grazeFX/Timer

onready var focus_layer : AnimationPlayer = $focus/AnimationPlayer
onready var death_timer : Timer = $DeathTimer

onready var tree := get_tree()
onready var user_data :UserData = Global.user_data

onready var sentivity := user_data.sentivity
var moving := false

export (PackedScene) var bomb_scene
var bomb_count := 1

func _ready():
	death_timer.connect('timeout', Global.leveler, 'restart')
	Global.connect("bullet_graze", self, '_graze')
	Global.connect("bomb_impact", self, '_bomb_impact')
	
	death_timer.wait_time = Global.score.death_time
	graze_timer.connect("timeout", graze_fx, 'set_emitting', [false])
	position = Vector2(307, 800)
	
func _unhandled_input(event:InputEvent):
	if event.is_action_released("bomb"):
		bomb()
	elif event.is_action_pressed('drag'):
		moving = true
		focus_layer.play("show")
		return
	elif event.is_action_released('drag'):
		moving = false
		focus_layer.play_backwards("show")
		return
	
	if event is InputEventMouseMotion and moving:
		global_position += event.relative * sentivity
		position.x = clamp(position.x, 0.0, 604.0)
		position.y = clamp(position.y, 0.0, 906.0)

func _hit():
	if tree.paused:
		return
	
	set_process_unhandled_input(false)
	Global.leveler.screenfx.flash_red()
	death_timer.start()

	tree.paused = true
	
func _graze():
	graze_fx.emitting = true
	graze_timer.start()

func bomb():
	if not bomb_count:
		return
		
	Global.leveler.hud._update_bomb()
	Global.leveler.screenfx.hide()
	death_timer.stop_all()
	death_timer.reset_all()
	
	collision_layer = 0
	graze.collision_layer = 0
	modulate = Color(1.0, 1.0, 1.0, .5)
	if Global.can_shoot:
		tree.call_group('player_bullet', 'stop')
	
	add_child(bomb_scene.instance())
	tree.paused = false
	set_process_unhandled_input(true)
	
func _bomb_impact():
	collision_layer = 4
	graze.collision_layer = 8
	modulate = Color.white
	if Global.can_shoot:
		tree.call_group('player_bullet', 'start')
