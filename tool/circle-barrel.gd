@tool
extends CollisionShape2D
class_name CircleBarrel
#Create a bunch of barrels node in circle.

#How to use:
#1. Change the radius of CirleShape2D however you want.
#2. Click the Add node checkbox.

#You can reparent all the child node after that.
#Uncheck if you want to remove all the barrels (in case all the barrel is still children of this node)

@export var add_node := false : set = _add_node
@export var barrels := 4
@export var gizmo := 20

func _ready():
	shape = CircleShape2D.new()

func _add_node(value:bool):
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
			
			angle += deltaR
			node.set_owner(get_tree().edited_scene_root)
		return
		
	var children = get_children()
	for child in children:
		child.queue_free()
	add_node = false
