extends Area2D
class_name Boss

signal start_spell

export (int) var point := 64
export (int) var hp := 10
export (float) var duration := 0.0

onready var gauge :TextureProgress = $Gauge/TextureProgress

var updating_gauge := false
var player_bomb_damage := 0

const boss_spot := Vector2(323, 235)

func _bomb_impact():
	hp -= player_bomb_damage
	if not updating_gauge:
		updating_gauge = true
		call_deferred('_update_gauge')

func _ready():
	var tween :SceneTreeTween
	if hp:
		Global.connect("bomb_impact", self, "_bomb_impact")
		tween = gauge.fill_gauge(hp)
	else:
		Global.connect("bomb_finished", self, "_die")
		tween = gauge.fill_gauge(duration)
		tween.connect("finished", gauge, "_timer_start")

	tween.connect("finished", self, "emit_signal", ['ready'])

	tween.parallel().tween_property(self, 'global_position', boss_spot, 2.0)
	
func _die():
	if global_position != boss_spot:
		var tween := create_tween()
		tween.tween_property(self, 'global_position', boss_spot, 2.0)
		tween.connect("finished", Global.level, 'next_level')
		get_tree().call_group('enemy_bullet', 'stop')
		return

	Global.emit_signal('next_level')

func _hit():
	hp -= 1
	if not hp:
		Global.level.item_manager.SpawnItem(int(point * gauge.value / duration))
		_die()

	if not updating_gauge:
		updating_gauge = true
		call_deferred('_update_gauge')
		
func _update_gauge():
	gauge.value = hp
	updating_gauge = false
