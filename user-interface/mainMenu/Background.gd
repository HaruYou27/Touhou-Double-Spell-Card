extends Node2D
##Some fancy harmless crossfade animation.

var current_preview : Node2D
var new_preview : Node2D

var changing := false

func change_preview(preview:LevelPreview) -> void:
	if changing:
		#Avoid any thing weird happen when user abuse the code.
		#Better nothing happend than a unexpected error.
		#Since it's rare (I wonder who would change the level in less than .25 sec)
		#I'm too lazy for a better solution.
		#Should naturally recover the next time it triggered.
		return
		
	changing = true
	new_preview = preview.node_preview
	add_child(new_preview)
	var tween := create_tween()
	tween.tween_property(current_preview, 'modulate', Color.TRANSPARENT, .25)
	
	new_preview.modulate = Color.TRANSPARENT
	tween.tween_property(new_preview, 'modulate', Color.WHITE, .25)
	
	tween.finished.connect(_change_finished)
	
func _change_finished() -> void:
	remove_child(current_preview)
	current_preview = new_preview
	changing = false
