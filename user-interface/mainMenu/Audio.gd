extends GridContainer

onready var save := Global.save_data

onready var master_slider :AnimatedHSlider = $master
onready var bgm_slider :AnimatedHSlider = $bgm
onready var sfx_slider :AnimatedHSlider = $sfx

func _ready():
	master_slider.value = save.master_db
	bgm_slider.value = save.bgm_db
	sfx_slider.value = save.sfx_db

func _on_reset_pressed():
	master_slider.value = 0.0
	bgm_slider.value = 0.0
	sfx_slider.value = 0.0

func _on_master_value_changed(value):
	save.master_db = value

func _on_bgm_value_changed(value):
	save.bgm_db = value

func _on_sfx_value_changed(value):
	save.sfx_db = value
