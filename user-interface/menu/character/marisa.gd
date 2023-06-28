extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	
@onready var animator := $MasterSpark/AnimationPlayer
func _visibility_changed() -> void:
	if visible:
		animator.play("open_fire")
	else:
		animator.stop()
		animator.seek(0., true)
