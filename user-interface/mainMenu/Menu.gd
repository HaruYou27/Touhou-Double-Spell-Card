extends Control

@onready var animator := $MistyLake/AnimationPlayer
@onready var main := $Main

const ani_duration = .5
@onready var current_menu := main
var next_menu : Control
func change_menu(node:Control) -> void:
	next_menu = node
	next_menu.show()
	
	var tween := create_tween()
	tween.tween_property(current_menu, 'modulate', Color.TRANSPARENT, ani_duration)
	tween.tween_property(next_menu, 'modulate', Color.WHITE, ani_duration)
	tween.finished.connect(_change_finished)

func _change_finished() -> void:
	current_menu.hide()
	current_menu = next_menu

func _on_solo_pressed() -> void:
	Global.change_scene(global.lobby)

var host := false
@onready var enet_host := $EnetHost
@onready var connect_method := $Main/ConnectionMethod
func _on_host_pressed():
	host = true
	connect_method.popup_centered()

@onready var enet_join := $EnetJoin
func _on_join_pressed():
	host = true
	connect_method.popup_centered()

@onready var credits := $Credits
func _on_credits_pressed():
	change_menu(credits)
	animator.play("day")

@onready var language := $Language
func _on_language_pressed():
	change_menu(language)
	animator.play("day")
	
@onready var error := $error
func check_error(err:int) -> void:
	if err:
		error.dialog_text = 'Error ' + error_string(err)
		error.popup_centered()

func _on_back_pressed():
	change_menu(main)
	animator.play_backwards("day")

@onready var enet_h := $EnetHost
@onready var enet_j := $EnetJoin
func _on_connection_method_canceled():
	animator.play("day")
	if host:
		change_menu(enet_h)
	else:
		change_menu(enet_j)
	
@onready var webrtc_h := $WebRtcHost
@onready var webrtc_j := $WebRtcJoin
func _on_connection_method_confirmed():
	animator.play("day")
	if host:
		change_menu(webrtc_h)
	else:
		change_menu(webrtc_j)
