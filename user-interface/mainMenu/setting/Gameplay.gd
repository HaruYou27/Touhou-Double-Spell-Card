extends VBoxContainer

onready var death_assist :Button = $deathAssist
onready var cheat :Button = $cheat
onready var speed :HSlider = $speed
onready var duration :HSlider = $duration
onready var bomb :Button = $bomb
onready var invicible :Button = $invicible

onready var config :UserSetting = Global.user_setting

func _ready():
	death_assist.set_pressed_no_signal(config.death_assist)
	cheat.pressed = config.cheat
	speed.value = config.game_speed
	duration.value = config.assit_duration
	bomb.set_pressed_no_signal(config.infinity_bomb)
	invicible.set_pressed_no_signal(config.invicible)

func _on_cheat_toggled(button_pressed):
	config.cheat = button_pressed
	duration.editable = button_pressed
	speed.disabled = button_pressed
	
func _exit_tree():
	if config.cheat:
		Engine.time_scale = speed.value
	config.game_speed = speed.value
	config.assit_duration = duration.value
	config.infinity_bomb = bomb.pressed
	config.invicible = invicible.pressed
	config.death_assist = death_assist.pressed

func _on_reset_pressed():
	death_assist.set_pressed_no_signal(true)
	cheat.pressed = false
	speed.value = 1.0
	duration.value = .3
	bomb.set_pressed_no_signal(false)
	invicible.set_pressed_no_signal(false)
