extends Area2D
class_name Boss

signal start_event

@onready var bomb_damage := 0.0
@onready var gauge : BossGauge = $Gauge

func _ready() -> void:
	Global.boss = self
	Global.bomb_impact.connect(Callable(self,"_bomb_hit"))

func setup(value:float, timer:bool) -> void:
	monitorable = false
	
	var tween := create_tween()
	if timer:
		tween = gauge.fill_gauge(value)
		tween.finished.connect(Callable(gauge,"timer_start"))
	else:
		tween = gauge.fill_gauge(value)
		tween.finished.connect(Callable(self, '_set_monitorable').bind(true))
		
	tween.finished.connect(Callable(self, 'emit_signal').bind('start_event'))
	
func _bomb_hit() -> void:
	gauge.value -= bomb_damage
	_hit()
	
func _hit() -> void:
	gauge.value -= 1
	if gauge.value <= 0:
		Global.leveler.next_event()
