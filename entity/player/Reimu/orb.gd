extends Sprite
class_name Satellite
#Simulate momentum.

var is_stopped := true
export var max_distance := 17
onready var previous_pos := global_position

func _physics_process(_delta):
	if previous_pos == global_position:
		if not is_stopped:
			create_tween().tween_property(self, 'position', Vector2.ZERO, .15)
			is_stopped = true
		return
	
	is_stopped = false
	position += global_position - previous_pos
	previous_pos = global_position
	position = position.limit_length(max_distance)
