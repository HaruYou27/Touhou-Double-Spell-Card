extends Node2D
class_name Player
#Script handles movement, stats, graze and animation.

var input : Object
var cooldown := 0
var max_lives := 7
var max_spellcard := 7
var power := 0.0
var spellcard := 3.0
var lives := 2
var graze := 0

export (int) var bullet_speed
export (int) var bullet_focus_speed
export (Resource) var bullet
export (Resource) var bullet_focus

export (Array) var barrels
export (int) var firerate
export (int) var firerate_focus
export (int) var speed = 1500 

onready var sprite :AnimatedSprite = $AnimatedSprite
onready var canvas :RID = $hitbox.get_canvas_item()
onready var shape :Shape2D = $hitbox/CollisionShape2D.shape
onready var main_barrel :Position2D = $Position2D

func _ready() -> void:
	var input_method = Global.save.controls['Input']
	if input_method == 'Keyboard and mouse':
		input = preload("res://entity/player/keyboard.gd").new()
		input.parent = self
	elif input_method == 'Touch':
		input = preload("res://entity/player/touch.gd").new()
		var UI
		if Global.save.controls['Lefthanded']:
			UI = Global.instance_node('res://user-interface/moblie-control/left-handed.tscn')
		else:
			UI = Global.instance_node('res://user-interface/moblie-control/right-handed.tscn')
		input.init(UI)
	
	var index := 0
	for barrel in barrels:
		barrels[index] = get_node(barrel)
		index += 1
		
	firerate = (60 - firerate) / firerate
	firerate_focus = (60 - firerate_focus) / firerate_focus

func die():
	pass
	
func attack():
	if cooldown:
		cooldown -= 1
		return
	
func attack_focus():
	if cooldown:
		cooldown -= 1
		return
	
#Input handler.
func _physics_process(delta) -> void:
	if graze:
		power += 0.01

	var velocity = input.move()
	
	if input.focus:
		attack_focus()
	else:
		attack()
	
	if not velocity:
		return
	
	#Warp around if exceed the border
	global_position += velocity * speed * delta
	global_position = global_position.posmodv(Vector2(1920, 1080))
	
	if input.focus:
		shape.draw(canvas, Color(255, 255, 255))
	if velocity.x > 0:
		#Right.
		pass
	elif velocity.x < 0:
		#Left.
		pass

func _on_hitbox_area_entered(_area) -> void:
	if Global.save.assist:
		Global.tree.pause_mode = Node.PAUSE_MODE_STOP
	else:
		lives -= 1
		if lives >= 0:
			pass

func _on_graze_area_entered(_area):
	graze += 1

func _on_graze_area_exited(_area):
	graze -= 0
