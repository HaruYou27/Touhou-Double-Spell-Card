extends Area2D
class_name Boss

signal next

export (float) var max_hp :float
export (float) var spell_length

onready var hp := max_hp
onready var init_position = global_position
onready var tween :SceneTreeTween
onready var hp_tween := create_tween()
onready var parent = get_parent()

onready var time_gauge :TextureProgress = $gauge/timeGauge
onready var heath_gauge :TextureProgress = $gauge/heathGauge

func _ready() -> void:
	time_gauge.max_value = spell_length
	heath_gauge.max_value = max_hp
	tween = create_tween()
	tween.tween_property(self, 'global_position', init_position, 1.0)
	tween.parallel().tween_property(time_gauge, 'value', spell_length, 1.0)
	tween.parallel().tween_property(heath_gauge, 'value', max_hp, 1.0)
	tween.connect("finished", self, '_start', [], 4)
	tween.connect("finished", parent, '_start', [], 4)
	Global.boss = self
	
func _start() -> void:
	tween = create_tween()
	tween.tween_property(time_gauge, 'value', 0.0, spell_length)
	#tween.connect("finished", get_node('/root/Stage'), '_next')

func _on_meimu_body_entered(body) -> void:
	body._hit()

func _hit() -> void:
	heath_gauge.value -= 1.0
	hp = heath_gauge.value
	if not hp:
		emit_signal("next")
		return
	
	
