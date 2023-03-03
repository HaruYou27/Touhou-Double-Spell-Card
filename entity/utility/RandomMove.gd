extends Node

@export (Vector2) var range_start := Vector2(322, 256)
@export (Vector2) var range_end := Vector2(328, 152)
@export (float) var duration := 3.0

@onready var parent := get_parent()
@onready var rand := RandomNumberGenerator.new()

func _ready():
	rand.randomize()

func start():
	var tween := create_tween()
	tween.tween_property(parent, 'global_position',
	Vector2(rand.randi_range(range_start.x, range_end.x), 
			rand.randi_range(range_start.y, range_end.y)), duration)
	tween.tween_callback(Callable(self,'start'))
