extends GPUParticles2D

func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	
@onready var trail := $trail
func  _visibility_changed() -> void:
	emitting = is_visible_in_tree()
	trail.emitting = emitting
