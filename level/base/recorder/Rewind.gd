
extends Node

@onready var viewport := get_viewport()
@onready var screenshot := viewport.get_texture()
@onready var thread := Thread.new()

@onready var replayer :Sprite2D = $Replayer

func _record():
	screenshot.get_data().save_png(replayer.path % replayer.frame_count)
	replayer.frame_count += 1

func rewind():
	var tree := get_tree()
	if not Global.user_data.rewind:
		tree.paused = false
		tree.reload_current_scene()
		return
	
	replayer.show()
	replayer.set_process(true)
	replayer.frame_delta = 3.0 / replayer.frame_count
	
func _process(_delta):
	if thread.is_alive():
		return
	
	thread.wait_to_finish()
	thread.start(Callable(self,'_record').bind(null),Thread.PRIORITY_LOW)
