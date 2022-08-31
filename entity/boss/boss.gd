extends Area2D
class_name boss

export (int) var hp
export (float) var spell_length

onready var init_position = global_position
onready var tween := create_tween()
onready var parent = get_parent()

onready var time_gauge :TextureProgress = $timeGauge
onready var heath_gauge :TextureProgress = $heathGauge

func _ready() -> void:
	time_gauge.max_value = spell_length
	heath_gauge.max_value = hp
	tween.tween_property(self, 'global_position', init_position, 2)
	tween.parallel().tween_property(time_gauge, 'value', spell_length, 2)
	tween.parallel().tween_property(heath_gauge, 'value', hp, 2)
	tween.connect("finished", self, '_start', [], 4)
	tween.connect("finished", parent, '_start', [], 4)
	
func _start() -> void:
	tween.tween_property(time_gauge, 'value', 0.0, spell_length)
	tween.connect("finished", Global, '_next')

func _on_meimu_body_entered(body) -> void:
	body._hit()

func _hit() -> void:
	heath_gauge.value -= Global.player_damage
