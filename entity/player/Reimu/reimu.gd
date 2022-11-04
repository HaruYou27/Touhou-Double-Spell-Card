extends StaticBody2D
class_name Player

signal die

onready var hitFx : Sprite = $hitFx
onready var hitSFX : AudioStreamPlayer = $hitFx/hitSfx

onready var graze : StaticBody2D = $graze
onready var graze_fx : Particles2D = $graze/grazeFX
onready var graze_timer : Timer = $graze/grazeFX/Timer

onready var focus_layer : Sprite = $focus
onready var tree := get_tree()

onready var bombs := Global.save_data.init_bomb
onready var playground := Global.playground
onready var death_time = Global.save_data.death_time
onready var death_tween :Tween = $hitFx/Tween

var input :Node

export (PackedScene) var bomb_scene

func _ready() -> void:
	Global.player = self
	Global.connect("graze", self, '_graze')
	
	remove_child(hitFx)
	graze_timer.connect("timeout", graze_fx, 'set_emitting', [false])
	death_tween.connect("tween_all_completed", Rewind, 'rewind')
	death_tween.interpolate_property(hitFx, 'scale', Vector2.ONE, Vector2(.01, .01), Global.save_data.death_time)
	
	if Global.save_data.use_mouse:
		input = MouseHandler.new(self)
		focus()
	else:
		input = KeyboardHandler.new(self)
	add_child(input)
	
	var timer :Timer = $Timer
	var timer2 :Timer = $Timer2
	if Global.save_data.auto_shoot:
		timer.start()
		timer2.start()
		
func _physics_process(_delta):
	position = position.posmodv(playground)
	
func _hit() -> void:
	if tree.paused:
		return
	
	input.pause()
	emit_signal('die')
	
	add_child(hitFx)
	hitSFX.play()
	death_tween.start()
	
	tree.paused = true
	
func _graze() -> void:
	graze_fx.emitting = true
	graze_timer.start()

func unfocus() -> void:
	create_tween().tween_property(focus_layer, 'modulate', Color.transparent, .15)
	
func focus() -> void:
	create_tween().tween_property(focus_layer, 'modulate', Color.white, .15)

func bomb() -> void:
	if not bombs:
		return
		
	death_tween.stop_all()
	death_tween.reset_all()
	remove_child(hitFx)
	
	bombs -= 1
	collision_layer = 0
	graze.collision_layer = 0
	modulate = Color(1.0, 1.0, 1.0, .5)
	
	if Global.save_data.auto_shoot:
		tree.call_group('player_bullet', 'stop')
		
	var bomb_node :Node = bomb_scene.instance()
	bomb_node.connect('done', self, '_bomb_done')
	bomb_node.connect('done', input, '_bomb_done')
	add_child(bomb_node)
	Global.emit_signal("bomb")
	
	tree.paused = false

func _bomb_done():
	collision_layer = 4
	graze.collision_layer = 8
	modulate = Color.white
	
	if Global.save_data.auto_shoot:
		tree.call_group('player_bullet', 'start')
