extends PathFollow2D
class_name PathFollower

export (float) var time
export (bool) var backward

export (NodePath) var visual_node

onready var tween := create_tween()
onready var timer :Timer = $Timer
onready var bullet :Node2D = $bullet

func _ready() -> void:
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if backward:
		unit_offset = 1.0
		tween.tween_property(self, 'unit_offset', 0.0, time)
	else:
		tween.tween_property(self, 'unit_offset', 1.0, time)
		
	tween.connect("finished", get_node(visual_node), 'queue_free')
	tween.connect("finished", self, '_on_die')
	if loop:
		tween.set_loops()
		
	timer.connect("timeout", bullet, 'SpawnBullet')
	timer.connect("timeout", $Timer/sfx, 'play')
	
	Global.connect("impact", self, 'bomb')

func _on_die():
	tween.kill()
	timer.queue_free()
	for barrel in bullet.get_children():
		barrel.queue_free()

func bomb():
	bullet.Flush()
	var orb = get_node_or_null('orb')
	if orb:
		Global.emit_signal("collect", orb.point)
	queue_free()
