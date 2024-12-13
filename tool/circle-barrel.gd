@tool
extends CollisionShape2D
class_name CircleBarrel
## Create a bunch of barrels node in circle.


## Add node around circle radius.
## Uncheck if you want to remove all the node.
@export var add_node := false : set = add_nodes
## The total number of child nodes.
@export var barrels := 4
## All the child nodes will be of this group.
@export var node_group := ''
## Child node are Marked2D.
@export var gizmo := 20

func _ready():
	shape = CircleShape2D.new()

## Call this func to add child nodes.
func add_nodes(value:bool):
	if value:
		add_node = true
		var deltaR : float = 2 * PI / barrels
		var angle := 0.0
		for _i in range(barrels):
			var node = Marker2D.new()
			add_child(node)
			node.position = Vector2(shape.radius, 0).rotated(angle)
			node.rotation = angle
			node.gizmo_extents = gizmo
			if not node_group.is_empty():
				node.add_to_group(node_group, true)
			
			angle += deltaR
			node.set_owner(get_tree().edited_scene_root)
		return
		
	var children = get_children()
	for child in children:
		child.queue_free()
	add_node = false
