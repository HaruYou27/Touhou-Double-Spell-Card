class_name Item_Valuable
#Resource contains shared data between items of the same type.

export (bool) var power
export (bool) var blue_point
export (bool) var mana
export (int) var value

export (int) var life_time
export (StreamTexture) var texture
export (Vector2) var scale = Vector2(1, 1)

var size :Vector2
var query :Physics2DShapeQueryParameters
var hitbox :RID

func _init():
	Global.queue_init.append(self)
	Global.set_process(true)

func init() -> void:
	size = texture.get_size()
	size *= scale
	
	hitbox = Physics2DServer.circle_shape_create()
	Physics2DServer.shape_set_data(hitbox, size.x)
	
	query = Physics2DShapeQueryParameters.new()
	query.collision_layer = 2
	query.shape_rid = hitbox
