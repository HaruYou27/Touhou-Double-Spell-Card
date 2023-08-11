extends BulletBasic

func spawn_item(point:int, pos:Vector2) -> void:
	var idx := 0
	while idx < point:
		idx +=1
		create_item(pos)
		
func create_item(pos:Vector2) -> void:
	create_bullet()
	
	var ranf := sin(Time.get_ticks_usec())
	var rot := ranf * TAU
	bullet.transform = Transform2D(rot, pos)
	bullet.velocity = Vector2(ranf * 17, 0).rotated(rot)
	bullets.append(bullet)

func move(delta:float, bullete:Bullet) -> void:
	#Simulate gravity.
	bullete.velocity.y += 98 * delta
	bullete.transform = bullete.transform.rotated_local(speed)
	super(delta, bullete)

func collide(result:Dictionary) -> bool:
	var mask = int(result["linear_velocity"].x)
	if mask == 1:
		return false
	else:
		Global.item_collect.emit()
	return false
