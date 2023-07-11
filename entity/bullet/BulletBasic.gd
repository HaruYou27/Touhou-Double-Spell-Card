extends Node2D
class_name BulletBasic

#Bullet shared properties.
@export var barrelGroup := ''
@export var speed := 525
@export var localRotation := false
@export var grazable := true
@export var bullet_scale := Vector2.ONE
var barrels : Array[Node]
#Query properties
@export var hitbox : Shape2D
@export var collide_with_areas := false
@export var collide_with_bodies := true
@export_flags_2d_physics var collision_mask := 1
var query := PhysicsShapeQueryParameters2D.new()
#Visual.
@export var texture : Texture2D
@onready var texture_rect := Rect2(-texture.get_size() / 2, texture.get_size())

@onready var world := get_world_2d()
@onready var tree := get_tree()
var bullets : Array[Bullet] = []
var cache : Array[Bullet] = []
var bullet : Bullet

func _ready() -> void:
	if barrelGroup.is_empty():
		barrels = get_children()
	else:
		barrels = tree.get_nodes_in_group(barrelGroup)
	query.shape = hitbox
	query.collide_with_areas = collide_with_areas
	query.collide_with_bodies = collide_with_bodies
	query.collision_mask = collision_mask
	
func create_bullet() -> void:
	bullet = Bullet.new()

func create_sprite() -> void:
	var sprite = RenderingServer.canvas_item_create()
	bullet.sprite = sprite
	
	RenderingServer.canvas_item_set_z_index(sprite, z_index)
	RenderingServer.canvas_item_set_parent(sprite, world.canvas)
	texture.draw_rect(sprite, texture_rect, false)
	RenderingServer.canvas_item_set_material(sprite, material.get_rid())
	
func _exit_tree() -> void:
	#Rid is actually an memory address to get the object in Godot server.
	#Since these CanvasItem are created directly using RenderingServer (not reference counted),
	#it must be freed manually.
	for bullete in bullets:
		RenderingServer.free_rid(bullete.sprite)
		
func new_bullet():
	if cache.is_empty():
		create_bullet()
		create_sprite()
		bullets.append(bullet)
	else:
		bullet = cache.pop_back()
		bullets.append(bullet)
		
func spawn_bullet() -> void:
	for barrel in barrels:
		if not barrel.is_visible_in_tree():
			continue
		new_bullet()
		
		RenderingServer.canvas_item_set_visible(bullet.sprite, true)
		RenderingServer.canvas_item_set_transform(bullet.sprite, Transform2D(0, Vector2(-500, -500)))		
		reset_bullet()
		reset_bullet_transform(barrel)
		
		bullet.grazable = grazable

func reset_bullet() -> void:
	pass
		
func reset_bullet_transform(barrel:Node2D):
	#Has to separate bullet velocity and transform because Capsule collision shape in Godot is vertical fuck it.
	if localRotation:
		bullet.velocity = Vector2(speed, 0).rotated(barrel.rotation)
		bullet.transform = Transform2D(barrel.rotation + PI/2, bullet_scale, 0, barrel.global_position)
	else:
		bullet.velocity = Vector2(speed, 0).rotated(barrel.global_rotation)
		bullet.transform = Transform2D(barrel.global_rotation + PI/2, bullet_scale, 0, barrel.global_position)
			
func clear() -> PackedVector2Array:
	if bullets.is_empty():
		return PackedVector2Array()
	var positions = PackedVector2Array()
	for bullete in  bullets:
		RenderingServer.canvas_item_set_visible(bullete.sprite, false)
		positions.append(bullete.transform.origin)
		
	return positions

func move(delta:float) -> Transform2D:
	bullet.transform.origin += bullet.velocity * delta
	return bullet.transform

func collide(result:Dictionary) -> bool:
	#Return true means the bullet will still alive.
	if int(result["linear_velocity"].x) == -1:
		#Hit the wall.
		return false
		
	var collider = instance_from_id(result["collider_id"])
	if bullet.grazable and collider is StaticBody2D:
		bullet.grazable = false
		Global.bullet_graze.emit()
		return true
		
	if collider is Player:
		collider.call("_hit")
		return false
		
	#Hit Player spellcard
	#Turn into an item.
	ItemManager.spawn_item(1, bullet.transform.origin)
	return false

func _physics_process(delta:float) -> void:
	if bullets.is_empty():
		return
		
	for index in range(bullets.size() -1, -1, -1):
		bullet = bullets[index]
		query.transform = move(delta)
		RenderingServer.canvas_item_set_transform(bullet.sprite, query.transform)
		if bullet.grazable:
			query.collision_mask = collision_mask + 8
		else:
			query.collision_mask = collision_mask
	
		#Since most bullet hit wall, get_rest_info provide a faster way to check (linear_velocity).
		#Tho it did make harder to get collider object, but the bullet rarely hit the target anyways.
		var result := world.direct_space_state.get_rest_info(query)
		if result.is_empty() or collide(result):
			continue
		RenderingServer.canvas_item_set_visible(bullet.sprite, false)
		#Sort from tail to head to minimize array access.
		cache.append(bullets.pop_at(index))
