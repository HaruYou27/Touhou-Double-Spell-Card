extends Control
class_name BulletPreviewer

@export var paths : Array[NodePath]
var nodes : Array[Node]

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	for path in paths:
		nodes.append(get_node(path))

func _visibility_changed() -> void:
	if is_visible_in_tree():
		for node in nodes:
			if node is Timer:
				node.start()
				continue
			elif node is AnimatedSprite2D or node is AnimationPlayer:
				node.play()
	else:
		for node in nodes:
			if node is Timer or node is AnimatedSprite2D or node is AnimationPlayer:
				node.stop()
				continue
