extends Path2D
class_name Path2DSpawner

@export var child_count := 1
@export var scene : PackedScene
var available : Array[Path2D]
func _ready() -> void:
	for i in range(child_count):
		var follower := scene.instantiate()
		follower.died.connect(_remove_follower.bind(follower))
		available.append(follower)
func _remove_follower(follower:Node) -> void:
	remove_child(follower)
	available.append(follower)

@export var mirror := false
var tick := true
func _on_spawn_timer_timeout():
	var follower : PathFollower2D = available.pop_back()
	if not follower:
		return
		
	follower.reverse = tick
	add_child(follower)
	
	if mirror:
		tick = not tick
