extends Bullet
#Bullet that follow a target.

var target :Node2D
var name :int

func create(latency:float) -> bool:
	name = Global.entity_index
	.create(latency)
	return target.is_network_master()

func move(delta:float) -> Transform2D:
	rotation = global_position.angle_to_point(target.position)
	velocity = Vector2(target.speed * 1.5, 0).rotated(rotation)
	
	var transform := .move(delta)
	Global.rpc_unreliable('_bullet_transform_update', name, transform)
	return transform
	
func destroy() -> void:
	if Global.is_network_master():
		Global.rpc('_bullet_destroy', name)
	.destroy()
