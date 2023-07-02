extends Sprite2D

@onready var fog := $fog
@onready var fog_overlay := $FogOverlay
func _ready():
	fog.modulate = Color.TRANSPARENT
	fog_overlay.modulate = Color.TRANSPARENT
	var tween := create_tween()
	tween.tween_property(fog, 'modulate', Color(1, 1, 1, 0.50588238239288), 30.)
	tween.parallel().tween_property(fog_overlay, 'modulate', Color.WHITE, 60.)
