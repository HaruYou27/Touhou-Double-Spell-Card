extends Enemy

@onready var visual := $phantom
var tween : Tween
func start() -> void:
	visual.show()
	position = Vector2.ZERO
	tween = create_tween()
	tween.tween_property(self, 'position', Vector2(0, -1050), 7.)
	tween.tween_callback(emit_signal.bind("died"))

func die() -> void:
	super()
	visual.hide()
