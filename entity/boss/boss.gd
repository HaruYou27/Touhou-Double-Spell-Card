extends Area2D
class_name boss

signal next

export (float) var max_hp :float
export (float) var spell_length

onready var hp := max_hp
onready var init_position = global_position
onready var tween :SceneTreeTween
onready var hp_tween := create_tween()
onready var parent = get_parent()

onready var time_gauge :TextureProgress = $timeGauge
onready var heath_gauge :TextureProgress = $heathGauge

func _ready() -> void:
	time_gauge.max_value = spell_length
	heath_gauge.max_value = max_hp
	tween = create_tween()
	tween.tween_property(self, 'global_position', init_position, 2)
	tween.parallel().tween_property(time_gauge, 'value', spell_length, 2)
	tween.parallel().tween_property(heath_gauge, 'value', max_hp, 2)
	tween.connect("finished", self, '_start', [], 4)
	tween.connect("finished", parent, '_start', [], 4)
	
func _start() -> void:
	tween = create_tween()
	tween.tween_property(time_gauge, 'value', 0.0, spell_length)
	tween.connect("finished", get_node('/root/Stage'), '_next')

func _on_meimu_body_entered(body) -> void:
	body._hit()

func _hit() -> void:
	hp -= 1.0
	if not hp:
		emit_signal("next")
		return
		
	hp_tween.kill()
	hp_tween = create_tween()
	hp_tween.tween_property(heath_gauge, 'value', hp, 0.15)
	
	
