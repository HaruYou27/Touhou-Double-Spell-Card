extends PathFollow2D
class_name  PathFollower2D

signal died

@export var time := 0.
@export var reverse := false

@onready var tween := create_tween()
func  _ready() -> void:
	if reverse:
		progress_ratio = 1.
		tween.tween_property(self, 'progress_ratio', 0., time)
	else:
		progress_ratio = 0.
		tween.tween_property(self, 'progress_ratio', 1., time)
	
	tween.tween_callback(queue_free)

@export var hp := 1
@onready var max_hp := hp
func _hit() -> void:
	hp -= 1 
	if hp < 0:
		die()
		
func die() -> void:
	print(hp)
	ItemManager.SpawnItem(max_hp, global_position)
	VisualEffect.death_vfx(global_position)
	died.emit()
	queue_free()

func _on_hitbox_body_entered(body) -> void:
	if body is Player:
		body._hit()
	else:
		hp = 0
		_hit()
