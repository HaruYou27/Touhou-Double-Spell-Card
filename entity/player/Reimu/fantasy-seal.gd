extends Node2D

signal done

onready var seals = [$seal1, $seal2, $seal3, $seal4]
onready var local_pos = PoolVector2Array([Vector2(), Vector2(), Vector2(), Vector2()])
var velocities := PoolVector2Array([Vector2(128.0, 0.0), Vector2(-128.0, 0.0), Vector2(0.0, 128.0), Vector2(0.0, -128.0)])

onready var tree := get_tree()
onready var hp_tween := create_tween()
onready var query := Physics2DShapeQueryParameters.new()
onready var world := get_viewport().world_2d

var seal :Particles2D

func _ready() -> void:
	query.collision_layer = 2
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.shape_rid = $CollisionShape2D.shape.get_rid()
	
	var tween = create_tween()
	tween.tween_property(self, 'modulate', Color(1.0, 1.0, 1.0, 1.0), 1.0)
	tween.connect("finished", self, '_attack')
	
	set_physics_process(false)

func _attack() -> void:
	set_physics_process(true)
	seal = seals.pop_back()

func _physics_process(delta:float) -> void:
	var velocity :Vector2 = Global.boss.global_position - seal.global_position
	seal.global_position += velocity.normalized() * delta * 727
	query.transform = seal.global_transform
	
	if not world.direct_space_state.get_rest_info(query).size():
		return
	
	#Impact
	tree.call_group('enemy', 'destroy')
	tree.call_group('bullet', 'Flush')
	ItemManager.autoCollect = true
	OS.delay_msec(15)
	Global.emit_signal("shake", 0.5)
	Global.emit_signal("explosive")
	
	var boss = Global.boss
	boss.hp -= boss.max_hp / 8
	hp_tween.kill()
	hp_tween = create_tween()
	hp_tween.tween_property(boss.heath_gauge, 'value', boss.hp, 1.0)
	
	seal.emitting = true
	seal.get_node('trail').emitting = false
	seal.get_node('orb').queue_free()
	if seals.size():
		seal = seals.pop_back()
	else:
		emit_signal("done")
		set_physics_process(false)
		set_process(false)
		var timer = tree.create_timer(2.0)
		timer.connect("timeout", self, 'queue_free')

func _process(delta:float) -> void:
	var index := 0
	var phi = TAU * delta
	for seal in seals:
		var velocity = velocities[index]
		seal.position = (local_pos[index] + velocity * delta).rotated(phi)
		local_pos[index] = seal.position
		seal.position += Global.player.global_position
		velocities[index] = velocity.rotated(phi)	
		index += 1
