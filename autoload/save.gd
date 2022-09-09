extends Resource
class_name saveData

#Controls
export (bool) var auto_shoot := true
export (bool) var use_mouse := true
export (float) var point_sentivity := 1.0

#Gameplay
export (bool) var assit_mode := false
export (float) var death_time := 1.0
export (int) var init_bomb := 3
export (float) var bomb_damage := 0.5

#Graphic
export (Vector2) var resolution := Vector2(960, 720) setget _set_resolution
export (bool) var fullscreen := false setget _set_fullscreen
export (bool) var borderless := false setget _set_borderless
export (bool) var screen_shake := true
export (bool) var screen_flash := true
export (bool) var vsync := false setget _set_vsync
export (int) var target_fps := 60 setget _set_target_fps

#Audio
export (float) var master_db := 0.0 setget _set_master_db
export (float) var bgm_db := 0.0 setget _set_bgm_db
export (float) var sfx_db := 0.0 setget _set_sfx_db

#Score
export (Dictionary) var hi_score := {}
export (Dictionary) var try_count := {}

onready var release := not OS.is_debug_build()

func new_save() -> void:
	var res := OS.get_screen_size().x
	match res:
		1080.0:
			self.resolution = Vector2(1280, 960)
		768.0:
			self.resolution = Vector2(960, 720)
		720.0:
			self.resolution = Vector2(720, 540)

func _set_sfx_db(value:float) -> void:
	sfx_db = value
	AudioServer.set_bus_volume_db(2, value)
	save()

func _set_bgm_db(value:float) -> void:
	bgm_db = value
	AudioServer.set_bus_volume_db(1, value)
	save()

func _set_master_db(value:float) -> void:
	master_db = value
	AudioServer.set_bus_volume_db(0, value)
	save()

func _set_resolution(value:Vector2) -> void:
	resolution = value
	OS.window_size = value
	save()
	
func _set_target_fps(value:int) -> void:
	target_fps = value
	Engine.target_fps = value
	save()
	
func _set_vsync(value:bool) -> void:
	vsync = value
	OS.vsync_enabled = value
	save()

func _set_borderless(value:bool) -> void:
	borderless = value
	OS.window_borderless = value
	save()

func _set_fullscreen(value:bool) -> void:
	fullscreen = value
	OS.window_fullscreen = value
	save()

func save() -> void:
	if release:
		ResourceSaver.save('user://save.res', self)
