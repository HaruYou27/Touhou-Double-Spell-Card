extends Node
## Load the main menu multi-threaded.

func _ready() -> void:
	LevelLoader.scene = self
	_load_menu.call_deferred()
	
func _load_menu() -> void:
	LevelLoader.load_scene(global.main_menu)
