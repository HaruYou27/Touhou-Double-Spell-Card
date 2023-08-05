extends BulletBasic

func spawn_item(point:int, pos:Vector2) -> void:
	var idx := 0
	while idx < point:
		idx +=1
		create_item(pos)
		
func create_item(pos:Vector2) -> void:
	new_bullet()
	
	var ranf := sin(Time.get_ticks_usec())
	var rot := ranf * TAU
	bullet.transform = Transform2D(rot, pos)
	bullet.velocity = Vector2(ranf * 17, 0).rotated(rot)
	RenderingServer.canvas_item_set_visible(bullet.sprite, true)
	RenderingServer.canvas_item_set_modulate(bullet.sprite, Color(Color.WHITE, ranf))

func move(delta:float) -> Transform2D:
	#Simulate gravity.
	bullet.velocity.y += 98 * delta
	return super(delta)

func collide(result:Dictionary) -> bool:

	var mask = int(result["linear_velocity"].x)
	if mask == 1:
		return false
	else:
		Global.item_collect.emit()
	return false;
