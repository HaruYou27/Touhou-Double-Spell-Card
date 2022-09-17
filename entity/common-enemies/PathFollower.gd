extends PathFollow2D
class_name PathFollower

export (float) var time
export (bool) var backward

export (NodePath) var visual_node
export (Array) var bullet_node

var tween : SceneTreeTween

func _ready() -> void:
	tween = create_tween()
	if backward:
		unit_offset = 1.0
		tween.tween_property(self, 'unit_offset', 0.0, time)
	else:
		tween.tween_property(self, 'unit_offset', 1.0, time)
		
	tween.connect("finished", get_node(visual_node), 'queue_free')
	if loop:
		tween.set_loops()

func _on_orb_die():
	tween.kill()
	for node in bullet_node:
		var bullet = get_node(node)
		bullet.shooting = false
		bullet.remove_from_group('bullet')
		
		for barrel in bullet.get_children():
			barrel.queue_free()
	
