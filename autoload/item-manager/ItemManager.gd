extends BulletBasic

func spawn_item(point:int, pos:Vector2) -> void:
	var idx := 0
	while idx < point:
		idx +=1
		create_item(pos)
		
func create_item(pos:Vector2) -> void:
	var item := create_bullet()
	
	var ranf := sin(Time.get_ticks_usec())
	var rot := ranf * TAU
	item.transform = Transform2D(rot, pos)
	item.velocity = Vector2(ranf * 17, 0).rotated(rot)
	bullets.append(item)

func move(delta:float, item:Bullet) -> void:
	#Simulate gravity.
	item.velocity.y += 98 * delta
	item.transform = item.transform.rotated_local(speed)
	super(delta, item)

func collide(result:Dictionary, item:Bullet) -> bool:
	var mask = int(result["linear_velocity"].x)
	if mask == 1:
		return false
	else:
		Global.item_collect.emit()
	return false
