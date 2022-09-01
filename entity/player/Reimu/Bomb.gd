extends Node2D

signal done

onready var seal1 :Particles2D = $seal
onready var seal2 :Particles2D = $seal2
onready var seal3 :Particles2D = $seal3
onready var seal4 :Particles2D = $seal4
onready var seals = [seal1, seal2, seal3, seal4]

onready var tree := get_tree()
onready var hp_tween := create_tween()
onready var shape :CollisionShape2D = $CollisionShape2D

var seal :Particles2D
var velocities := PoolVector2Array([Vector2(128.0, 0.0), Vector2(-128.0, 0.0), Vector2(0.0, 128.0), Vector2(0.0, -128.0)])

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, 'modulate', Color(1.0, 1.0, 1.0, 1.0), 1.0)
	tween.connect("finished", self, '_attack')
	
	set_physics_process(false)

func _attack() -> void:
	set_physics_process(true)
	seal = seals.pop_back()
	shape.position = seal.position

func _physics_process(delta:float) -> void:
	var velocity :Vector2 = Global.boss.global_position - shape.global_position
	shape.global_position += velocity.normalized() * delta * 727
	seal.global_position = shape.global_position

func _process(delta:float) -> void:
	var index := 0
	for seal in seals:
		var velocity = velocities[index]
		var phi := TAU * delta
		seal.position += velocity * delta
		seal.position = seal.position.rotated(phi)
		velocities[index] = velocity.rotated(phi)
		index += 1

func _on_Bomb_area_entered(_area):
	tree.call_group('enemy', 'destroy')
	tree.call_group('bullet', 'Flush')
	var boss = Global.boss
	boss.hp -= boss.max_hp * Global.save.bomb_damage / 4
	hp_tween.kill()
	hp_tween = create_tween()
	hp_tween.tween_property(boss.heath_gauge, 'value', boss.hp, 1.0)
	
	seal.emitting = false
	seal.get_node('trail').emitting = false
	seal.get_node('explosion').emitting = true
	if seals.size():
		seal = seals.pop_back()
		shape.position = seal.position
	else:
		emit_signal("done")
		$Timer.start()

func _on_Timer_timeout():
	queue_free()
