class_name Gunpowder
#Resource contains shared data between bullets of the same type.

#Bullet physics.
export (int) var speed = 1000
export (int) var life_time = 5
export (int, LAYERS_2D_PHYSICS) var mask
export (bool) var instant_delete
export (bool) var pierce
export (int) var damage
export (bool) var use_texture_as_collision
export (Vector2) var hitbox_size

#Bullet visual.
export (StreamTexture) var texture
export (Material) var material
export (Vector2) var scale = Vector2(1, 1)
export (int, -4096, 4096) var z_index

var texture_size : Vector2
var offset :Vector2
var hitbox :RID
var query :Physics2DShapeQueryParameters
var parent

func _init():
	Global.queue_init.append(self)
	Global.set_process(true)

func init() -> void:
	life_time *= 1000
	texture_size = texture.get_size()
	texture_size *= scale
	offset = -texture_size / 2
	
	#Bullet collision shape.
	if use_texture_as_collision:
		if texture_size.x == texture_size.y:
			create_shape(true, texture_size)
		else:
			hitbox = Physics2DServer.capsule_shape_create()
			Physics2DServer.shape_set_data(hitbox, texture_size)
	elif hitbox_size.x == hitbox_size.y:
		hitbox = Physics2DServer.circle_shape_create()
		Physics2DServer.shape_set_data(hitbox, hitbox_size.x)
	else:
		hitbox = Physics2DServer.capsule_shape_create()
		Physics2DServer.shape_set_data(hitbox, hitbox_size)

	query = Physics2DShapeQueryParameters.new()
	query.shape_rid = hitbox
	query.collision_layer = mask
	query.collide_with_areas = true

func create_shape(shape:bool, size:Vector2):
	if shape:
		hitbox = Physics2DServer.circle_shape_create()
		Physics2DServer.shape_set_data(hitbox, size.x)
