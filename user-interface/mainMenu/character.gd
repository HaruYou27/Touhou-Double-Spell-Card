extends Control

onready var back :Button = $back
onready var back_label :Label = $back/Label
onready var tween := create_tween()

func _on_back_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(back, 'modulate', Color(0, 0.44, 1, 1), 0.15)
	tween.parallel().tween_property(back_label, 'rect_position', Vector2(7, 91), .15)

func _on_back_focus_exited():
	var tween := create_tween()
	tween.tween_property(back, 'modulate', Color.white, 0.15)
	tween.parallel().tween_property(back_label, 'rect_position', Vector2(7, 71), .15)

func _on_back_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(back, 'modulate', Color(.93, .09, .05, 1), .15)
