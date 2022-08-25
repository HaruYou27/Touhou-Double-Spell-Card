extends ColorRect

onready var tween : Tween = $Tween

func _ready():
	tween.interpolate_property($meimu/bullet/Position2D, "rotation", 0, 6.28, 7)
