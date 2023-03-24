extends Node
class_name Rewind
##Just a very performance hungry visual effect.

@onready var screenshot := get_viewport().get_texture()

@onready var thread := Thread.new()

##Just does the opposite of this node, I'm too lazy for another doc.
@onready var replayer :Sprite2D = $Replayer

##Record the whole [Viewport] and save it into a png file.
func _record() -> void:
	screenshot.get_image().save_png(replayer.path % replayer.frame_count)
	replayer.frame_count += 1

##Stop recording and playback instead.
func rewind() -> void:
	var tree := get_tree()
	if not Global.user_data.rewind:
		tree.paused = false
		tree.reload_current_scene()
		return
	
	replayer.show()
	replayer.set_process(true)
	replayer.frame_delta = 3.0 / replayer.frame_count
	
func _process(_delta:float) -> void:
	if thread.is_alive():
		return
	
	thread.wait_to_finish()
	thread.start(Callable(self,'_record'),Thread.PRIORITY_LOW)
