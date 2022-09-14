extends ColorRect

var orb := preload("res://level/reimu-meimu/enemy/yinyang-orb.scn")
onready var paths := [$Path2D, $Path2D2]

func _spawn_orb() -> void:
	for path in paths:
		path.add_child(orb.instance())
		
func _start() -> void:
	$Timer.start()
