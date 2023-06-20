extends Node2D

@onready var background := $Background

var idx := 0
func _change_level(next:bool) -> void:
	animate(background.get_child(idx))
	if next:
		idx += 1
		if idx == background.get_child_count():
			idx = 0
	else:
		idx -= 1
	background.get_child(idx).show()

@onready var previewer := $Previewer
func animate(previous:Node2D) -> void:
	var tween := create_tween()
	tween.tween_property(previewer, 'position', previewer.position + Vector2(540,0), .5)
	tween.finished.connect(previous.hide)
