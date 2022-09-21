extends Node

onready var viewport := get_viewport()
onready var screenshot := viewport.get_texture()
onready var thread := Thread.new()

onready var replayer :Sprite = $Replayer

func _ready():
	set_process(false)

func _record() -> void:
	screenshot.get_data().save_png(replayer.path % replayer.frame_count)
	replayer.frame_count += 1

func rewind() -> void:
	replayer.show()
	replayer.set_process(true)
	replayer.frame_delta = 2.0 / replayer.frame_count
	set_process(false)

func _process(_delta) -> void:
	if thread.is_alive():
		return
	
	thread.wait_to_finish()
	thread.start(self, '_record', null, Thread.PRIORITY_LOW)
