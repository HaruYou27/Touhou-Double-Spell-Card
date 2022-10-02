extends HBoxContainer

onready var save := Global.save_data

onready var fps :ScrollButton = $TabContainer/Graphic/GridContainer/fps
onready var resolution :ScrollButton = $TabContainer/Graphic/GridContainer/resolution
onready var fullscreen :AnimatedTextButton = $TabContainer/Graphic/fullscreen
onready var borderless :AnimatedTextButton = $TabContainer/Graphic/borderless
onready var vsync :AnimatedTextButton = $TabContainer/Graphic/vsync

func _ready() -> void:
	vsync.pressed = save.vsync
	fullscreen.pressed = save.fullscreen
	borderless.pressed = save.borderless
	resolution.item = resolution.items.find(save.resolution)
	fps.item = fps.items.find(save.target_fps)
	
func _on_reset_pressed():
	AudioServer.set_bus_volume_db(2, -80)
	
	fps.item = 1
	resolution.item = 1
	vsync.pressed = false
	fullscreen.pressed = false
	borderless.pressed = false
	
	AudioServer.set_bus_volume_db(2, 0)

func _on_vsync_toggled(button_pressed):
	save.vsync = button_pressed

func _on_fullscreen_toggled(button_pressed):
	save.fullscreen = button_pressed
	resolution.disabled = button_pressed

func _on_borderless_toggled(button_pressed):
	save.borderless = button_pressed

func _on_resolution_item_changed(item):
	save.resolution = item

func _on_fps_item_changed(item):
	save.target_fps = item
