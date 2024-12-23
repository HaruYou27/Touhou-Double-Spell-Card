extends RotatorRandom
class_name Rotator
## Should only be use on bosses.

@export var speed := -PI

func _ready() -> void:
	set_physics_process(is_multiplayer_authority())

func _physics_process(delta: float) -> void:
	rotation += speed * delta
	#rotation = wrapf(rotation, min_rad, max_rad)
	rpc("sync_rotation", rotation)

@rpc("authority", "call_remote", "unreliable_ordered")
func sync_rotation(rot:float) -> void:
	rotation = rot

func transform_barrel() -> void:
	return
	
