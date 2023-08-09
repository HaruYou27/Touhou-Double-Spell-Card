extends Node2D
class_name BulletBasic
##The most basic bullet.
## Shoule be in grayscale for dynamic color.
@export var texture : Texture2D
## By default bullet texture is draw in center.
@onready var texture_rect := Rect2(-texture.get_size() / 2, texture.get_size())

@export_category("Barrel")
## Node group where bullets come out.
@export var barrelGroup := ''
## Pixel per second.
@export var speed := 525
## Bullet travel direction ignore global transform.
@export var localRotation := false
## Allow bullet to be grazed by player.
@export var grazable := true
## Want BIG bullet?
@export var bullet_scale := Vector2.ONE
## Array of where bullets will come out. For performance reason, this will only get update ONCE at startup.
var barrels : Array[Node]

@export_category("Physics")
## Use Circle or Capsule shape for best performance.
@export var hitbox : Shape2D
## Should be enable for player bullet. Enemy always use Area2D.
@export var collide_with_areas := false
## Leave this alone for enemy bullet. Player alwasy use Body.
@export var collide_with_bodies := true
## Never tick on Graze layer.
@export_flags_2d_physics var collision_mask := 1
var query := PhysicsShapeQueryParameters2D.new()

@onready var world := get_world_2d()
@onready var tree := get_tree()
## Array of active bullets.
var bullets : Array[Bullet] = []
## Inactive bullet array, exist for performance reason.
var cache : Array[Bullet] = []
## Current bullet in physics process.
var bullet : Bullet
@onready var collision_graze := collision_mask + 8

func _ready() -> void:
	if barrelGroup.is_empty():
		barrels = get_children()
	else:
		barrels = tree.get_nodes_in_group(barrelGroup)
	query.shape = hitbox
	query.collide_with_areas = collide_with_areas
	query.collide_with_bodies = collide_with_bodies
	
## Override it with your new Bullet class.
func create_bullet() -> void:
	bullet = Bullet.new()

## Incase someone want to change how the bullet is drawn.
func create_sprite() -> void:
	var sprite = RenderingServer.canvas_item_create()
	bullet.sprite = sprite
	
	RenderingServer.canvas_item_set_z_index(sprite, z_index)
	RenderingServer.canvas_item_set_parent(sprite, world.canvas)
	texture.draw_rect(sprite, texture_rect, false)
	RenderingServer.canvas_item_set_material(sprite, material.get_rid())
	RenderingServer.canvas_item_set_transform(bullet.sprite, Transform2D(0, Vector2(-500, -500)))
	
func _exit_tree() -> void:
	#Rid is actually an memory address to get the object in Godot server.
	#Since these CanvasItem are created directly using RenderingServer (not reference counted),
	#it must be freed manually.
	for bullete in bullets:
		RenderingServer.free_rid(bullete.sprite)
		
## Just a few line of code to check for bullet in cache.
func new_bullet():
	if cache.is_empty():
		create_bullet()
		create_sprite()
		bullets.append(bullet)
	else:
		bullet = cache.pop_back()
		bullets.append(bullet)
		
## Bang
func spawn_bullet() -> void:
	for barrel in barrels:
		if not barrel.is_visible_in_tree():
			continue
		new_bullet()
		
		RenderingServer.canvas_item_set_visible(bullet.sprite, true)
		reset_bullet_transform(barrel)
		reset_bullet()
		
		bullet.grazable = grazable

## If you add any extra properties to the bullet, reset it to default here.
func reset_bullet() -> void:
	pass
		
const half_pi := PI/2
## Capsule collision shape in Godot is vertical.
func reset_bullet_transform(barrel:Node2D):
	if localRotation:
		bullet.velocity = Vector2(speed, 0).rotated(barrel.rotation)
		bullet.transform = Transform2D(barrel.rotation + half_pi, bullet_scale, 0, barrel.global_position)
	else:
		bullet.velocity = Vector2(speed, 0).rotated(barrel.global_rotation)
		bullet.transform = Transform2D(barrel.global_rotation + half_pi, bullet_scale, 0, barrel.global_position)
			
## Wipe all bullets.
func clear() -> void:
	if bullets.is_empty():
		return 
	for bullete in bullets:
		RenderingServer.canvas_item_set_visible(bullete.sprite, false)

## Override to change the way bullet move.
func move(delta:float, bullete:Bullet) -> void:
	bullete.transform.origin += bullete.velocity * delta
	RenderingServer.canvas_item_set_transform(bullete.sprite, bullete.transform)

## Bulelt has collided with something, what to do now?
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

func _process_bullet(delta:float) -> void:
	for bullete in bullets.duplicate():
		move(delta, bullete)

func collision_check() -> void:
	pass
	
var tick := false
var task_id := 0
func _physics_process(delta:float) -> void:
	if bullets.is_empty():
		return
		
	task_id = WorkerThreadPool.add_task(_process_bullet.bind(delta), true)
	
	var start_index := bullets.size() - 1
	var end_index := int(bullets.size() / 2)
	tick = not tick
	if tick:
		start_index = end_index
		end_index = -1
	
	for index in range(start_index, end_index, -1):
		bullet = bullets[index]
		collision_check()
		query.transform = bullet.transform
		if bullet.grazable:
			query.collision_mask = collision_graze
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
	WorkerThreadPool.wait_for_task_completion(task_id)
