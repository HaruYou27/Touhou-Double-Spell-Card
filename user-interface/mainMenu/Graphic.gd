extends VBoxContainer

onready var tween := create_tween()
onready var orb :Sprite = $Button/YinyangOrb

const red := Color(.93, .09, .05, 1)
const blue := Color(0, 0.44, 1, 1)
const time := .15

onready var fullscreen :CheckButton = $fullscreen
onready var borderless :CheckButton = $borderless

func _on_fullscreen_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 26), time)
	tween.parallel().tween_property(fullscreen, 'rect_position', Vector2(10, 0), time)
	tween.parallel().tween_property(fullscreen, 'modulate', blue, time)

func _on_fullscreen_focus_exited():
	var tween := create_tween()
	tween.tween_property(fullscreen, 'rect_position', Vector2(0, 0), time)
	tween.parallel().tween_property(fullscreen, 'modulate', Color.white, time)

func _on_borderless_focus_entered():
	pass # Replace with function body.

func _on_borderless_focus_exited():
	pass # Replace with function body.
