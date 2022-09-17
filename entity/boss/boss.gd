extends Area2D
class_name Boss

signal next

export (float) var hp :float
export (float) var time_limit
export (int) var points

onready var init_position = global_position
onready var tween :SceneTreeTween
onready var max_hp := hp

onready var time_gauge :TextureProgress = $gauge/timeGauge
onready var heath_gauge :TextureProgress = $gauge/heathGauge

func _ready() -> void:
	time_gauge.max_value = time_limit
	heath_gauge.max_value = hp
	tween = create_tween()
	tween.tween_property(self, 'global_position', init_position, 1.0)
	tween.parallel().tween_property(time_gauge, 'value', time_limit, 1.0)
	tween.parallel().tween_property(heath_gauge, 'value', hp, 1.0)
	tween.connect("finished", self, '_start', [], 4)
	tween.connect("finished", get_parent(), '_start', [], 4)
	Global.boss = self
	
func _start() -> void:
	tween = create_tween()
	tween.tween_property(time_gauge, 'value', 0.0, time_limit)

func _on_meimu_body_entered(body) -> void:
	body._hit()

func _hit() -> void:
	heath_gauge.value -= 1.0
	hp = heath_gauge.value
	if not hp:
		emit_signal("next")
		return
	
	
