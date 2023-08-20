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
var query := PhysicsShapeQueryParameters2D.new()

@onready var world := get_world_2d()
@onready var tree := get_tree()
## Array of active bullets.
var bullets : Array[Bullet] = []
@onready var collision_graze := collision_mask + 8
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
	
## Bang
func spawn_bullet() -> void:
	for barrel in barrels:
		if not barrel.is_visible_in_tree():
			continue
		var bullet := create_bullet()
		bullets.append(bullet)
		set_bullet_transform(barrel, bullet)
		
		bullet.grazable = grazable
	
## Capsule collision shape in Godot is vertical.
const half_pi := PI / 2
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

var bullet_modulate := Color.WHITE
## Override to change the way bullet move.
func move(delta:float, bullet:Bullet) -> void:
	bullet.transform.origin += bullet.velocity * delta
	var bullet_rotation = bullet.transform.get_rotation()
	bullet_modulate.r = bullet_rotation
	bullet_modulate.g = bullet_rotation
	texture.draw(canvas_item, bullet.transform.origin.rotated(-bullet_rotation) / bullet.transform.get_scale(), bullet_modulate)

## Bulelt has collided with something, what to do now?
func collide(result:Dictionary, bullet:Bullet) -> bool:
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
		collider._hit()
		return true
		
	#Hit Player spellcard
	#Turn into an item.
	ItemManager.spawn_item(1, bullet.transform.origin)
	return false

func _process_bullet(delta:float) -> void:
	RenderingServer.canvas_item_clear(canvas_item)
	for bullet in bullets:
		move(delta, bullet)

func collision_check(_bullet:Bullet) -> void:
	pass
	
var tick := false
var task_id := 0
var index := 0
func _physics_process(delta:float) -> void:
	if bullets.is_empty():
		return
		
	task_id = WorkerThreadPool.add_task(_process_bullet.bind(delta), true)
	
	var end_index := 0
	tick = not tick
	if tick:
		end_index = bullets.size() / 2
		index = bullets.size()
	
	var new_bullets = bullets.duplicate()
	while index > end_index:
		index -= 1	
		var bullet = bullets[index]
		
		collision_check(bullet)
		query.transform = bullet.transform
		if bullet.grazable:
			query.collision_mask = collision_graze
		else:
			query.collision_mask = collision_mask
		
		#Since most bullet hit wall, get_rest_info provide a faster way to check (linear_velocity).
		#Tho it did make harder to get collider object, but the bullet rarely hit the target anyways.
		var result := world.direct_space_state.get_rest_info(query)
		if result.is_empty() or collide(result, bullet):
			continue
		#Sort from tail to head to minimize array access.
		new_bullets.remove_at(index)

	WorkerThreadPool.wait_for_task_completion(task_id)
	bullets = new_bullets
	index = end_index
	
