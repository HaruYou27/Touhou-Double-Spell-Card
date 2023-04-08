extends Resource
class_name LevelHeader

@export var scene : PackedScene
@export var id := 0
@export var title := 'Test Level'
@export var preview_bg := 0
@export_range(0, 2) var difficulty_level := 0
@export var bgm_seek := 0.
