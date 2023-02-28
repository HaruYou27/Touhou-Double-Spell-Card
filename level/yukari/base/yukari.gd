extends Area2D
class_name Boss

export (int) var point := 64
export (int) var hp := 10 setget _set_hp
export (float) var duration := 0.0

onready var bomb_damage := hp / 2
onready var physics_layer := collision_layer
onready var gauge :TextureProgress = $Gauge

var updating_gauge := false

const boss_spot := Vector2(307, 222)

func _ready():
	collision_layer = 0
	var tween :SceneTreeTween
	if hp:
		tween = gauge.fill_gauge(hp)
	else:
		tween = gauge.fill_gauge(duration)
		tween.connect("finished", gauge, "_timer_start")

	tween.connect("finished", self, '_start')
	Global.connect("bomb_impact", self, "_set_hp", [bomb_damage])
	
func _start():
	Global.leveler.level.start()
	
func _hit():
	hp -= 1
	
func _set_hp(damage):
	hp -= damage
	if not hp:
		Global.leveler.item_manager.SpawnItem(int(point * gauge.value / duration))
		Global.leveler.next_level()

	if not updating_gauge:
		updating_gauge = true
		call_deferred('_update_gauge')

func _update_gauge():
	gauge.value = hp
	updating_gauge = false
