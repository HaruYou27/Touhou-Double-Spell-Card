extends BulletBasic

func spawn_item(count:int, pos:Vector2) -> void:
	var i := 1
	while i <= count:
		var item := create_bullet()
		var rot := TAU * sin(pos.x * pos.y * i)
		item.velocity = Vector2(speed, 0).rotated(rot)
		item.transform = Transform2D(rot, pos)
		
		bullets.append(item)
		i += 1

## Don't call this function.
func spawn_bullet() -> void:
	return

@export var gravity := 98
@export var speed_angular := 0.0525
## Simulate gravity.
func move(delta:float, item:Bullet) -> void:
	item.velocity.y += gravity * delta
	item.transform = item.transform.rotated_local(speed_angular)
	super(delta, item)

func collide(result:Dictionary, _item:Bullet) -> bool:
	var mask = int(result["linear_velocity"].x)
	if mask == 1:
		return false
		
	var collider: Node = instance_from_id(result["collider_id"])
	if collider.is_multiplayer_authority():
		Global.item_collect.emit()
		
	return false
