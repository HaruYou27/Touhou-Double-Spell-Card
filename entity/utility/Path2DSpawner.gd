extends Path2D
class_name Path2DSpawner

@onready var available := get_children()
func _ready() -> void:
	for follower in available:
		follower.died.connect(_reclaim_follower.bind(follower))

func _reclaim_follower(follower:Node) -> void:
	available.append(follower)

@export var mirror := false
var tick := true
func _on_spawn_timer_timeout():
	var follower : PathFollower2D = available.pop_back()
	if not follower:
		return
		
	follower.reverse = tick
	follower.start()
	
	if mirror:
		tick = not tick
