extends Node2D
class_name Player

var input : Script
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
		input = load("res://autoload/controls/keyboard.gd")

func _set_power(value:float) -> void:
	power += value
	orb

func die():
	pass

func _on_graze_area_entered(_area:Area2D) -> void:
	graze_count += 1

func _on_graze_area_exited(_area:Area2D) -> void:
	graze_count -= 1

#Input handler.
func _physics_process(delta:float) -> void:
	if graze_count:
		power += 0.01
	
	var new_pos :Vector2 = input.move(delta, global_position)
	var angle := global_position.angle_to_point(new_pos)
	if angle <= 90 or angle > -90:
		#Right.
		sprite
	else:
		#Left
		sprite
	
	global_position = new_pos
	
	if cooldown:
		cooldown -= 1
	elif Global.save.auto_shoot or Input.is_action_pressed("shoot"):
		if Input.is_action_pressed("focus"):
			cooldown = firerate_focus
		else:
			cooldown = firerate
