extends Control
class_name BulletPreviewer

@export var nodes : Array[NodePath]

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)

func _visibility_changed() -> void:
	if visible:
		for node in nodes:
			if node is Timer:
				node.start()
				continue
			elif node is AnimatedSprite2D or AnimationPlayer:
				node.play()
	else:
		
