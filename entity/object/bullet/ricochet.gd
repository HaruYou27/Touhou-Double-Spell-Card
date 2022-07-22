extends Bullet
#Bullets that bounce off wall.
export (int) var ricochet = 1

func _collide() -> bool:
	if ricochet:
		ricochet -= 1
		var result = Global.space_state.intersect_ray(global_position, 
			velocity, [], data.mask)
		velocity = velocity.bounce(result['normal'])
		
		return false
	
	return ._collide()
