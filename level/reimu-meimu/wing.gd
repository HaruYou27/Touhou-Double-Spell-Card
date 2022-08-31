extends ColorRect

onready var meimu :Area2D = $meimu
onready var barrel :Node2D = $meimu/bullet
onready var barrel2 :Node2D = $meimu/bullet2

func _ready() -> void:
	var phi = meimu.position.angle_to_point(Global.player.position)
	barrel.rotation += phi
	barrel2.rotation += phi
	barrel.set_physics_process(false)
	barrel2.set_physics_process(false)
	set_physics_process(false)

func _physics_process(delta) -> void:
	barrel.rotation += 0.897 * delta
	barrel2.rotation -= 0.897 * delta
	
func _start() -> void:
	barrel.set_physics_process(true)
	barrel2.set_physics_process(true)
	set_physics_process(true)
