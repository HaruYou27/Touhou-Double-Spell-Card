extends Node
## Load the main menu multi-threaded.

func _ready() -> void:
	LevelLoader.load_scene(global.main_menu)
