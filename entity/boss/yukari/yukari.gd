extends Area2D
class_name boss

export (int) var point := 64
export (int) var hp := 10
export (float) var duration := 0.0

onready var hp_gauge :TextureProgress = $HeathGauge
onready var time_gauge :TextureProgress = $TimeGauge

func _ready():
	hp_gauge.max_value = hp
	hp_gauge.value = hp
	if duration:
		time_gauge.max_value = duration
		time_gauge.value = duration
		var tween := create_tween()
		tween.tween_property(time_gauge, 'value', 0.0, duration)
		tween.connect("finished", Global, 'emit_signal', ['next_level'])
	else:
		time_gauge.queue_free()
		hp_gauge.radial_fill_degrees = 360
		hp_gauge.radial_initial_angle = 0
		
func _hit():
	hp_gauge.value -= 1
	if not hp_gauge.value:
		Global.emit_signal("spawn_item", point)
		Global.emit_signal("next_level")
