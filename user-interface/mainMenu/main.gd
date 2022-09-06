extends Control

onready var tween := create_tween()
onready var orb :Sprite = $Button/YinyangOrb

onready var new :Button = $Button/New
onready var Continue :Button = $Button/Continue
onready var help :Button = $Button/Help
onready var options :Button = $Button/Options
onready var credits :Button = $Button/Credits
onready var quit :Button = $Button/Quit

func _on_New_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 26), 0.15)
	tween.parallel().tween_property(new, 'rect_position', Vector2(10, 0), 0.15)
	tween.parallel().tween_property(new, 'modulate', Color(0, 0.44, 1, 1), 0.15)

func _on_New_focus_exited():
	var tween := create_tween()
	tween.tween_property(new, 'rect_position', Vector2(0, 0), 0.15)
	tween.parallel().tween_property(new, 'modulate', Color.white, 0.15)

func _on_Continue_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 70), 0.15)
	tween.parallel().tween_property(Continue, 'rect_position', Vector2(10, 44), 0.15)
	tween.parallel().tween_property(Continue, 'modulate', Color(0, 0.44, 1, 1), 0.15)

func _on_Continue_focus_exited():
	var tween := create_tween()
	tween.tween_property(Continue, 'rect_position', Vector2(0, 44), 0.15)
	tween.parallel().tween_property(Continue, 'modulate', Color.white, 0.15)

func _on_Help_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 114), 0.15)
	tween.parallel().tween_property(help, 'rect_position', Vector2(10, 88), 0.15)
	tween.parallel().tween_property(help, 'modulate', Color(0, 0.44, 1, 1), 0.15)

func _on_Help_focus_exited():
	var tween := create_tween()
	tween.tween_property(help, 'rect_position', Vector2(0, 88), 0.15)
	tween.parallel().tween_property(help, 'modulate', Color.white, 0.15)

func _on_Options_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 158), 0.15)
	tween.parallel().tween_property(options, 'rect_position', Vector2(10, 132), 0.15)
	tween.parallel().tween_property(options, 'modulate', Color(0, 0.44, 1, 1), 0.15)

func _on_Options_focus_exited():
	var tween := create_tween()
	tween.tween_property(options, 'rect_position', Vector2(0, 132), 0.15)
	tween.parallel().tween_property(options, 'modulate', Color.white, 0.15)

func _on_Credits_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 202), 0.15)
	tween.parallel().tween_property(credits, 'rect_position', Vector2(10, 176), 0.15)
	tween.parallel().tween_property(credits, 'modulate', Color(0, 0.44, 1, 1), 0.15)

func _on_Credits_focus_exited():
	var tween := create_tween()
	tween.tween_property(credits, 'rect_position', Vector2(0, 176), 0.15)
	tween.parallel().tween_property(credits, 'modulate', Color.white, 0.15)

func _on_Quit_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 246), 0.15)
	tween.parallel().tween_property(quit, 'rect_position', Vector2(10, 220), 0.15)
	tween.parallel().tween_property(quit, 'modulate', Color(0, 0.44, 1, 1), 0.15)

func _on_Quit_focus_exited():
	var tween := create_tween()
	tween.tween_property(quit, 'rect_position', Vector2(0, 220), 0.15)
	tween.parallel().tween_property(quit, 'modulate', Color.white, 0.15)

func _on_New_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(new, 'modulate', Color(.93, .09, .05, 1), .15)

func _on_Continue_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(Continue, 'modulate', Color(.93, .09, .05, 1), .15)

func _on_Help_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(help, 'modulate', Color(.93, .09, .05, 1), .15)

func _on_Options_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(options, 'modulate', Color(.93, .09, .05, 1), .15)

func _on_Credits_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(credits, 'modulate', Color(.93, .09, .05, 1), .15)

func _on_Quit_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(quit, 'modulate', Color(.93, .09, .05, 1), .15)
