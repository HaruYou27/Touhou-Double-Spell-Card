tool
extends CollisionShape2D

#Create a bunch of barrels node in circle.
#How to use:
#Create a collisionShape2D node.
#Choose circleShape then shape it however you want.
#The step export variable is the number of barrels.
#Click the Add node checkbox.
#Done.
#You can reparent all the child node after that.

#Uncheck if you want to remove all the barrels (in case all the barrel is still children of this node)

export (bool) var add_node setget _add_node
export (int) var step := 4
export (float) var bullet_scale := 1.0
export (int) var gizmo := 20

func _add_node(value:bool) -> void:
	if value:
		add_node = true
		var deltaR : float = 2 * PI / step
		var angle : float
		for i in range(step):
			var node = Position2D.new()
			add_child(node)
			node.position = Vector2(shape.radius, 0).rotated(angle)
			node.rotation = angle
			node.scale = Vector2(bullet_scale, bullet_scale)
			node.gizmo_extents = gizmo
			
			angle += deltaR
			node.set_owner(get_tree().edited_scene_root)
		return
		
	var children = get_children()
	for child in children:
		child.queue_free()
	add_node = false
