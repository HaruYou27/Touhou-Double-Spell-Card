extends Area2D
class_name Boss

signal start_spell

export (int) var point := 64
export (int) var hp := 10
export (float) var duration := 0.0

onready var gauge :TextureProgress = $Gauge/TextureProgress

var updating_gauge := false
var player_bomb_damage := 0

const boss_spot := Vector2(307, 222)

func _ready():
	var tween :SceneTreeTween
	if hp:
		tween = gauge.fill_gauge(hp)
	else:
		tween = gauge.fill_gauge(duration)
		tween.connect("finished", gauge, "_timer_start")

	tween.connect("finished", self, "emit_signal", ['ready'])
	tween.parallel().tween_property(self, 'position', boss_spot, .25)
	
	Global.connect("bomb_impact", self, "_die")
	
func _die():
	Global.leveler.next_level()

func _hit():
	hp -= 1
	if not hp:
		Global.leveler.item_manager.SpawnItem(int(point * gauge.value / duration))
		_die()

	if not updating_gauge:
		updating_gauge = true
		call_deferred('_update_gauge')
		
func _update_gauge():
	gauge.value = hp
	updating_gauge = false
