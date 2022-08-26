extends ColorRect

onready var meimu :Area2D = $meimu
onready var barrel :Node2D = $meimu/bullet/Position2D

func _ready():
	randomize()
	barrel.rotation = rand_range(0.0, 6.28)

func _physics_process(delta) -> void:
	meimu.global_position.x += 72 * delta
	meimu.position.y += sin(Time.get_ticks_msec()) * 272 * delta
	meimu.global_position = meimu.global_position.posmodv(Global.playground)
	barrel.rotation += 0.897 * delta
