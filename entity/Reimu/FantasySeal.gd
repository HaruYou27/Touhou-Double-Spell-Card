extends Area2D

var target : Node2D
var velocity : Vector2

@onready var timer : Timer = $Timer
@onready var seek_shape : CollisionShape2D = $SeekShape

func _physics_process(delta:float) -> void:
	if is_instance_valid(target):
		velocity = (target.global_position - global_position).normalized() * 572
		global_position += velocity * delta
	else:
		timer.start(1.)
		seek_shape.set_deferred('disabled', false)
		set_physics_process(false)
		set_process(true)
		velocity = velocity.normalized() * 127

func _process(delta:float) -> void:
	global_position += velocity * delta

func explode() -> void:
	$orb.queue_free()
	$explosion.emitting = true
	set_physics_process(false)
	Global.bomb_impact.emit()
	area_entered.disconnect(Callable(self, '_on_area_entered'))
	
	timer.start(2.)
	timer.timeout.disconnect(Callable(self, 'explode'))
	timer.timeout.connect(Callable(self, 'queue_free'))

func _on_area_entered(area:Area2D) -> void:
	if not seek_shape.disabled:
		target = area
		set_physics_process(true)
		set_process(false)
		seek_shape.set_deferred('disabled', true)
	else:
		explode()
