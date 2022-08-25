extends Area2D
class_name boss

export (int) var hp
export (float) var spell_length

onready var init_position = global_position
onready var tween := create_tween()

func _ready() -> void:
	if global_position != init_position:
		tween.tween_property(self, 'global_position', init_position, 2)
		
func start() -> void:
	var timer = $Timer
	timer.wait_time = spell_length
	timer.start()

func _on_meimu_body_entered(body) -> void:
	body._hit()

func _hit() -> void:
	hp -= Global.player_damage

func _on_Timer_timeout():
	pass # Replace with function body.
