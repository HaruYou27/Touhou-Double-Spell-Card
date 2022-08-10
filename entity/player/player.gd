extends Node2D
class_name Player
#Script handles movement, stats, graze and animation.

var input : input_handler
var cooldown := 0
var power := 0.0 setget _set_power
var lives := 2
var graze_count := 0
var max_lives := 7

export (int) var firerate
export (int) var firerate_focus
export (Array) var barrels

onready var sprite :AnimatedSprite = $AnimatedSprite
onready var canvas :RID = $hitbox.get_canvas_item()
onready var shape :Shape2D = $hitbox/CollisionShape2D.shape
onready var orb :Node2D = $orb_manager
onready var bullet :Node2D = $bullet

func _ready() -> void:
	var index := 0
	for barrel in barrels:
		barrels[index] = get_node(barrel)
		index += 1
		
	firerate = (60 - firerate) / firerate
	firerate_focus = (60 - firerate_focus) / firerate_focus
	
	if Global.save.input == save_data.input.KEYBOARD:
		input = preload("res://autoload/keyboardHold.gd").new(self)

func _set_power(value:float):
	power += value

func die():
	pass

func _on_graze_area_entered(_area):
	graze_count += 1

func _on_graze_area_exited(_area):
	graze_count -= 1
	
func attack():
	if cooldown:
		cooldown -= 1
	else:
		bullet.SpawnBullet(transform)
		cooldown = firerate
	
func attack_focus():
	if cooldown:
		cooldown -= 1
	else:
		cooldown = firerate_focus
	
#Input handler.
func _physics_process(delta) -> void:
	#Grazing
	if graze_count:
		power += 0.01
	
	var velocity = Global.input.move(delta)
	
	if Global.save.shoot == save_data.shoot.AUTO or input.attack():
		if Global.focus:
			attack_focus()
		else:
			attack()
		
	#Warp around if exceed the border
	global_position = global_position.posmodv(Vector2(1920, 1080))
	
	if input.focus:
		shape.draw(canvas, Color(255, 255, 255))
	if velocity.x > 0:
		#Right.
		pass
	elif velocity.x < 0:
		#Left.
		pass
