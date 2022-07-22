extends KinematicBody2D
class_name Player
#Script handles movement, stats, graze and animation.

var previous_location : Vector2
var power := 0
var input : Object
var tick := false
var cooldown :int
var canvas :RID

export (Array) var bullets
export (Array) var barrels
export (int) var speed = 1500 
export (float) var graze_multipler = 1

onready var camera :Camera2D = $Camera2D
onready var sprite :AnimatedSprite = $AnimatedSprite
onready var shape :CircleShape2D = $hitbox/CollisionShape2D.shape
onready var graze :Area2D = $graze

func _ready() -> void:
	var hitbox = $hitbox
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
	
	camera.current = true
	$nametag.queue_free()
	var index := 0
	for barrel in barrels:
		barrels[index] = get_node(barrel)
		bullets[index].data.parent = self
		bullets[index].data.name = name
		index += 1
	canvas = hitbox.get_canvas_item()

remotesync func set_animtion(animation:String) -> void:
	pass
	
func fire(_data):
	pass
	
#Input handler.
func _draw():
	if input.focus:
		shape.draw(canvas, Color(255, 255, 255))
		input.focus = false

func _physics_process(_delta) -> void:
	#Attacking.
	if cooldown:
		cooldown -= 1
	
	var attacking = input.attack()
	if attacking:
		fire(attacking)
		if abs(attacking['Rotation']) >= 1.57:
			#Left.
			sprite.flip_h = false
		else:
			#Right.
			sprite.flip_h = true

	#Movement.
	var velocity = input.move()
	if not velocity:
		return
	velocity *= speed
	velocity = move_and_slide(velocity)
	previous_location = position
	
	#Flip the sprite if the player isn't attacking.
	if attacking:
		return
	if velocity.x > 0:
		#Right.
		sprite.flip_h = true
	elif velocity.x < 0:
		#Left.
		sprite.flip_h = false
