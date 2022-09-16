extends ColorRect

var orb := preload("res://level/reimu-meimu/enemy/yinyang-orb.scn")
onready var path1 := $Path2D
onready var path2 := $Path2D2

func _spawn_orb() -> void:
	path1.add_child(orb.instance())
	var node := orb.instance()
	node.backward = true
	path1.add_child(node)
		
func _start() -> void:
	$Timer.start()
