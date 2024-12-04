extends Node2D
class_name BulletBasic
##The most basic bullet.

## Shoule be in grayscale for dynamic color.
@export var texture : Texture2D

@export_category("Barrel")
## Node group where bullets come out.
@export var barrelGroup := ''
## Pixel per second.
@export var speed := 525.0
## Bullet travel direction ignore global transform.
@export var localRotation := false
## Allow bullet to be grazed by player.
@export var grazable := true
## Array of where bullets will come out. For performance reason, this will only get update ONCE at startup.
var barrels : Array[Node]

@export_category("Physics")
## Use Circle or Capsule shape for best performance.
@export var hitbox : Shape2D
## Should be enable for player bullet. Enemy always use Area2D.
@export var collide_with_areas := false
## Leave this alone for enemy bullet. Player alwasy use Body.
@export var collide_with_bodies := true
## Never tick on Graze layer, use Grazable instead.
@export_flags_2d_physics var collision_mask := 1
## Pass this to godot physics engine.
var query := PhysicsShapeQueryParameters2D.new()

## For collision checking.
@onready var world := get_world_2d()
## To get barrels nodes from nodegroup.
@onready var tree := get_tree()
## Array of active bullets.
var bullets : Array[Bullet] = []
## Hardcoded graze layer 8.
@onready var collision_graze := collision_mask + 8
## The bullet will be drawn on this node canvas item.
@onready var canvas_item := get_canvas_item()

func _ready() -> void:
	RenderingServer.canvas_item_set_custom_rect(canvas_item, true)
	barrels = tree.get_nodes_in_group(barrelGroup)
	
	query.shape = hitbox
	query.collide_with_areas = collide_with_areas
	query.collide_with_bodies = collide_with_bodies
	
## Override it with your new Bullet class.
func create_bullet() -> Bullet:
	return Bullet.new()
	
## Spawn bullet at barrel position.
func spawn_bullet() -> void:
	for barrel in barrels:
		if not barrel.is_visible_in_tree():
			continue
		var bullet := create_bullet()
		bullets.append(bullet)
		set_bullet_transform(barrel, bullet)
		
		bullet.grazable = grazable

## Just Pi/2
const half_pi := PI / 2

## Capsule collision shape in Godot is vertical.
func set_bullet_transform(barrel:Node2D, bullet:Bullet):
	var angle := 0.0
	if localRotation:
		angle = barrel.rotation
	else:
		angle = barrel.global_rotation
		
	bullet.velocity = Vector2(speed, 0).rotated(angle)
	bullet.transform = Transform2D(angle + half_pi, scale, 0.0, barrel.global_position)

## Wipe all bullets.
func restart() -> void:
	bullets.clear()
	RenderingServer.canvas_item_clear(canvas_item)

## Return true means the bullet is still alive.
func collide(result:Dictionary, bullet:Bullet) -> bool:
	var mask := int(result["linear_velocity"].x)
	if mask < -700:
		# Hit player bomb, turn into an item.
		ItemManager.spawn_item(1, bullet.transform.origin)
		return false
	elif mask < 0:
		# Hit the wall.
		return false
		
	var collider: Node = instance_from_id(result["collider_id"])
	if bullet.grazable:
		bullet.grazable = false
		if collider.is_multiplayer_authority():
			Global.bullet_graze.emit()
		return true
	
	collider.hit()
	return false

## Override to change the way bullet move.
func move(delta:float, bullet:Bullet) -> void:
	bullet.transform.origin += bullet.velocity * delta

## Do not override this function.
func _process_bullet(delta:float) -> void:
	for bullet in bullets:
		move(delta, bullet)

## Override this function to access collision
func collision_check(bullet:Bullet) -> bool:
	query.transform = bullet.transform
	if bullet.grazable:
		query.collision_mask = collision_graze
	else:
		query.collision_mask = collision_mask
	
	#Since most bullet hit wall, get_rest_info provide a faster way to check (linear_velocity).
	#Tho it did make harder to get collider object, but the bullet rarely hit the target anyways.
	var result := world.direct_space_state.get_rest_info(query)
	if result.is_empty():
		return true
	return collide(result, bullet)
	
## Pass this to the texture draw.
var bullet_modulate := Color.WHITE
## Override this function to change how bullet is drawn.
func draw_bullet(bullet:Bullet) -> void:
	var bullet_rotation = bullet.transform.get_rotation()
	bullet_modulate.r = bullet_rotation
	bullet_modulate.g = bullet_rotation
	texture.draw(canvas_item, bullet.transform.origin.rotated(-bullet_rotation) / bullet.transform.get_scale(), bullet_modulate)
	
## Do not override this function
func _draw_bullets() -> void:
	RenderingServer.canvas_item_clear(canvas_item)
	for bullet in bullets:
		draw_bullet(bullet)

## Only check collison half of the bullets every frame.
var tick := false

## Loop from back to head.

func _physics_process(delta:float) -> void:
	var index := 0
	if bullets.is_empty():
		return
		
	var move_task := WorkerThreadPool.add_task(_process_bullet.bind(delta), true)
	var draw_task := WorkerThreadPool.add_task(_draw_bullets, true)
	
	
	var end_index := 0
	tick = not tick
	if tick:
		end_index = bullets.size() / 2
		index = bullets.size()
	var new_bullets = bullets.duplicate()
	while index > end_index:
		index -= 1
		var bullet = bullets[index]
		
		if collision_check(bullet):
			continue
		#Sort from tail to head to minimize array access.
		new_bullets.remove_at(index)

	WorkerThreadPool.wait_for_task_completion(move_task)
	WorkerThreadPool.wait_for_task_completion(draw_task)
	
	bullets = new_bullets
	index = end_index
