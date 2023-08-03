extends Path2D
class_name Path2DSpawner

@onready var tree := get_tree()
@onready var available := get_children()
func _ready() -> void:
	for follower in available:
		follower.died.connect(_reclaim_follower.bind(follower))
	
	if barrel_group.is_empty():
		return
	barrels = tree.get_nodes_in_group(barrel_group)

func _reclaim_follower(follower:Node) -> void:
	available.append(follower)

## Spawn enemy from both end of the curve.
@export var mirror := false
@export var reverse := false
@export var spawn := false :
	set(value):
		if value:
			spawn_enemy()
var tick := false
func spawn_enemy():
	if available.is_empty():
		return
	var follower : PathFollower2D = available.pop_back()
		
	follower.reverse = tick or reverse
	follower.start()
	
	if mirror:
		tick = not tick

@export var barrel_group : StringName
var barrels
func _track_player():
	for barrel in barrels:
		if barrel.is_visible_in_tree():
			barrel.track()
