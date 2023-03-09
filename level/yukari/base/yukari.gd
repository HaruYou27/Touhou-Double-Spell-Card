extends Area2D
class_name Boss

@export var point := 64
@export var hp := 727
@export var duration := 0.0

@onready var bomb_damage := hp / 2
@onready var physics_layer := collision_layer
@onready var gauge :TextureProgressBar = $Gauge

var updating_gauge := false

const boss_spot := Vector2(307, 222)

func _ready() -> void:
	collision_layer = 0
	var tween :Tween
	if hp:
		tween = gauge.fill_gauge(hp)
	else:
		tween = gauge.fill_gauge(duration)
		tween.connect("finished",Callable(gauge,"_timer_start"))

	tween.connect("finished",Callable(self,'_start'))
	Global.connect("bomb_impact",Callable(self,"_set_hp").bind(bomb_damage))
	Global.boss = self
	
func _start() -> void:
	Global.leveler.level.start_level()
	
func _hit() -> void:
	hp -= 1
	if not hp:
		Global.leveler.next_level()

	if not updating_gauge:
		updating_gauge = true
		call_deferred('_update_gauge')
	
func _update_gauge() -> void:
	gauge.value = hp
	updating_gauge = false
