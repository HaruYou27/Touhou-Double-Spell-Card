class_name Enemy
extends Area2D

#Base class for common enemy (Not boss).

var alert :bool
var sleep :bool
var count := 30
var origin :Vector2
var target

export (Array) var barrels
export (Array) var bullets
export (int) var speed = 727
export (int) var max_heath = 10

onready var heath :int = max_heath
onready var cooldown :Timer = $Cooldown

#Behavior functions.
func _ready():
	var index := 0
	for barrel in barrels:
		barrels[index] = get_node(barrel)
		index += 1
	set_process(false)
	set_physics_process(false)

#Callback function.
func _hit(data:Gunpowder, velocity):
	heath -= data.damage
	alert = true
	count = 30
	set_process(true)
	
	if heath <= 0:
		die()

func die():
	pass
	
func remove_target(tag):
	if target.name == tag:
		target = null

#Optimize functions.
func sleep():
	if alert:
		sleep = true
		return
	pause_mode = Node.PAUSE_MODE_STOP
	
func wakeup():
	pause_mode = Node.PAUSE_MODE_INHERIT
	
#Synchronize functions.
puppetsync func set_animation(animation):
	pass
	
puppet func _puppet_position_update(new):
	Global.tween.interpolate_property(self, 'position', position, new, 0.1)
	Global.tween.start()
