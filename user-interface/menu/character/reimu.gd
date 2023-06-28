extends AnimatedSprite2D

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)

@onready var bullet := $bullet
@onready var timer := $Timer
func _visibility_changed() -> void:
	if is_visible_in_tree():
		timer.start()
	else:
		timer.stop()
		bullet.Clear()
