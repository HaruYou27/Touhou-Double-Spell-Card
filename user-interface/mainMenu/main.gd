extends Control

onready var tween := create_tween()
onready var orb :Sprite = $Button/YinyangOrb

onready var new :Button = $Button/New
onready var Continue :Button = $Button/Continue
onready var help :Button = $Button/Help
onready var options :Button = $Button/Options
onready var credits :Button = $Button/Credits
onready var quit :Button = $Button/Quit

const red := Color(.93, .09, .05, 1)
const blue := Color(0, 0.44, 1, 1)
const time := .15

func _ready():
	new.grab_focus()

func _on_New_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 26), time)
	tween.parallel().tween_property(new, 'rect_position', Vector2(10, 0), time)
	tween.parallel().tween_property(new, 'modulate', blue, time)

func _on_New_focus_exited():
	var tween := create_tween()
	tween.tween_property(new, 'rect_position', Vector2(0, 0), time)
	tween.parallel().tween_property(new, 'modulate', Color.white, time)

func _on_Continue_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 70), time)
	tween.parallel().tween_property(Continue, 'rect_position', Vector2(10, 44), time)
	tween.parallel().tween_property(Continue, 'modulate', blue, time)

func _on_Continue_focus_exited():
	var tween := create_tween()
	tween.tween_property(Continue, 'rect_position', Vector2(0, 44), time)
	tween.parallel().tween_property(Continue, 'modulate', Color.white, time)

func _on_Help_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 114), time)
	tween.parallel().tween_property(help, 'rect_position', Vector2(10, 88), time)
	tween.parallel().tween_property(help, 'modulate', blue, time)

func _on_Help_focus_exited():
	var tween := create_tween()
	tween.tween_property(help, 'rect_position', Vector2(0, 88), time)
	tween.parallel().tween_property(help, 'modulate', Color.white, time)

func _on_Options_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 158), time)
	tween.parallel().tween_property(options, 'rect_position', Vector2(10, 132), time)
	tween.parallel().tween_property(options, 'modulate', blue, time)

func _on_Options_focus_exited():
	var tween := create_tween()
	tween.tween_property(options, 'rect_position', Vector2(0, 132), time)
	tween.parallel().tween_property(options, 'modulate', Color.white, time)

func _on_Credits_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 202), time)
	tween.parallel().tween_property(credits, 'rect_position', Vector2(10, 176), time)
	tween.parallel().tween_property(credits, 'modulate', blue, time)

func _on_Credits_focus_exited():
	var tween := create_tween()
	tween.tween_property(credits, 'rect_position', Vector2(0, 176), time)
	tween.parallel().tween_property(credits, 'modulate', Color.white, time)

func _on_Quit_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(orb, 'position', Vector2(-26, 246), time)
	tween.parallel().tween_property(quit, 'rect_position', Vector2(10, 220), time)
	tween.parallel().tween_property(quit, 'modulate', blue, time)

func _on_Quit_focus_exited():
	var tween := create_tween()
	tween.tween_property(quit, 'rect_position', Vector2(0, 220), time)
	tween.parallel().tween_property(quit, 'modulate', Color.white, time)

func _on_New_button_down():
	new.modulate = red
	
func _on_Continue_button_down():
	Continue.modulate = red

func _on_Help_button_down():
	help.modulate = red

func _on_Options_button_down():
	options.modulate = red

func _on_Credits_button_down():
	credits.modulate = red

func _on_Quit_button_down():
	quit.modulate = red
