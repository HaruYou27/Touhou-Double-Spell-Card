extends Control

onready var back :Button = $back
onready var back_label :Label = $back/Label
onready var tween := create_tween()

onready var bgm :AudioStreamPlayer = get_parent().bgm
onready var tree := get_tree()

func _on_back_focus_entered():
	tween.kill()
	tween = create_tween()
	tween.tween_property(back, 'modulate', Color(0, 0.44, 1, 1), 0.15)
	tween.parallel().tween_property(back_label, 'rect_position', Vector2(102, 0), .15)

func _on_back_focus_exited():
	var tween := create_tween()
	tween.tween_property(back, 'modulate', Color.white, 0.15)
	tween.parallel().tween_property(back_label, 'rect_position', Vector2(82, 0), .15)

func _on_back_button_down():
	tween.kill()
	tween = create_tween()
	tween.tween_property(back, 'modulate', Color(.93, .09, .05, 1), .15)

func _on_vsync_toggled(button_pressed):
	ProjectSettings.set_setting('display/window/vsync/use_vsync ', button_pressed)

func _on_flash_toggled(button_pressed):
	Global.save_data.screen_flash = button_pressed
	Global.save_data.save()

func _on_shake_toggled(button_pressed):
	Global.save_data.screen_shake = button_pressed
	Global.save_data.save()

func _on_autoshoot_toggled(button_pressed):
	Global.save_data.auto_shoot = button_pressed
	Global.save_data.save()

func _on_fullscreen_toggled(button_pressed):
	ProjectSettings.set_setting('display/window/size/fullscreen', button_pressed)

func _on_borderless_toggled(button_pressed):
	ProjectSettings.set_setting('display/window/size/borderless', button_pressed)

func _on_back_pressed():
	back.disabled = true

func _on_Options_pressed():
	back.disabled = false

func _on_bgm_value_changed(value):
	bgm.volume_db = value

func _on_sfx_value_changed(value):
	tree.set_group('sfx', 'volume_db', value)
