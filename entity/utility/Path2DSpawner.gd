extends Path2D
class_name Path2DSpawner

@onready var tree := get_tree()
@onready var available := get_children()
func _ready() -> void:
	for follower in available:
		if follower is PathFollower2D:
			follower.enemy.died.connect(_reclaim_follower.bind(follower))

func _reclaim_follower(follower:Node) -> void:
	available.append(follower)

## Spawn enemy from both end of the curve.
@export var mirror := false
## Spawn enemy at the tail of the curve.
@export var reverse := false
var tick := false
func spawn_enemy() -> void:
	if available.is_empty():
		return
	var follower : PathFollower2D = available.pop_back()
		
	follower.reverse = tick or reverse
	follower.start()
	
	if mirror:
		tick = not tick
