class_name Bullet
#Resource that defines a bullet.

var time_created : float
var awake := true
var global_position :Vector2
var velocity :Vector2
var sprite :Object
var rotation :float

export (Script) var draw_method
export (Resource) var data

func create(latency:float) -> bool:
	sprite = draw_method.new()
	velocity = Vector2(data.speed, 0).rotated(rotation)
	sprite.create(data)
	
	#Recorrection bullet position.
	sprite.draw(move(latency))
	
	return true
	
func _collide() -> bool:
	#Called when a bullet hit something.
	if data.pierce:
		return false
		
	if not data.instant_delete:
		awake = false
		return false
	
	destroy()
	return true
	
func move(delta:float) -> Transform2D:
	global_position += velocity * delta
	return Transform2D(rotation, global_position)
	
func destroy() -> void:
	sprite.free_rid()
	
func process(delta:float) -> bool:
	if Network.server_clock - time_created > data.life_time:
		destroy()
		return true
	
	if not awake:
		return false
	var transform = move(delta)
	data.query.transform = transform
	sprite.draw(transform)
	var result = Global.space_state.intersect_shape(data.query, 1)
	
	if result.empty():
		return false
	if result[0]['collider'].has_method('_hit'):
		if not result[0]['collider']._hit(data, velocity):
			return false
			
	return _collide()
