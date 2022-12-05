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

onready var bombs := 3
onready var playground := Global.playground
onready var config := Global.config
onready var death_tween :Tween = $hitFx/Tween

var input :Node
var focus := false setget _set_focus

export (PackedScene) var bomb_scene

func _ready():
	Global.player = self
	Global.connect("graze", self, '_graze')
	if config.invicible:
		$hitbox.queue_free()
	
	remove_child(hitFx)
	graze_timer.connect("timeout", graze_fx, 'set_emitting', [false])
	death_tween.connect("tween_all_completed", Rewind, 'rewind')
	death_tween.interpolate_property(hitFx, 'scale', Vector2.ONE, Vector2(.01, .01), Global.config.assit_duration)
	
	if config.use_mouse:
		input = MouseHandler.new(self)
	else:
		input = KeyboardInput.new(self)
	add_child(input)
	
	if config.auto_shoot:
		$bullet/Timer.start()
		$bullet2/Timer2.start()
		
func _physics_process(_delta):
	position.x = clamp(position.x, 0.0, playground.x)
	position.y = clamp(position.y, 0.0, playground.y)
	
func _hit():
	if tree.paused:
		return
	
	input.pause()
	emit_signal('die')
	
	add_child(hitFx)
	hitSFX.play()
	death_tween.start()
	
	tree.paused = true
	
func _graze():
	graze_fx.emitting = true
	graze_timer.start()

func _set_focus(value:bool):
	if value:
		create_tween().tween_property(focus_layer, 'modulate', Color.white, .15)
		return
		
	create_tween().tween_property(focus_layer, 'modulate', Color.transparent, .15)
	

func bomb():
	if not bombs:
		return
		
	death_tween.stop_all()
	death_tween.reset_all()
	remove_child(hitFx)
	
	if not config.infinity_bomb:
		bombs -= 1
	collision_layer = 0
	graze.collision_layer = 0
	modulate = Color(1.0, 1.0, 1.0, .5)
	
	if config.auto_shoot:
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
	
	if config.auto_shoot:
		tree.call_group('player_bullet', 'start')
