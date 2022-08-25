extends Area2D
class_name boss

export (int) var max_hp
export (float) var spell_length

onready var hp :int = max_hp
onready var init_position = global_position
onready var tween := create_tween()
onready var parent = get_parent()

var timer : SceneTreeTimer
	
func _ready() -> void:
	if global_position != init_position:
		tween.tween_property(self, 'global_position', init_position, 2)
		tween.connect("finished", self, 'start', [], 4)
	set_process(false)
		
func _process(_delta) -> void:
	timer.time_left
		
func start() -> void:
	timer = get_tree().create_timer(spell_length)
	timer.connect("timeout", parent, 'next')
	set_process(true)

func _on_meimu_body_entered(body) -> void:
	body._hit()

func _hit() -> void:
	hp -= Global.player_damage
