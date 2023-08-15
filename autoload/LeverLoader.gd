extends Control

func load_scene(path:String) -> void:
	show()
	scene.queue_free()
	progess_bar.value = 25.0
	task_id = WorkerThreadPool.add_task(_instance_scene.bind(path))

@onready var progess_bar := $ProgressBar
func _instance_scene(path:String) -> void:
	var packed : PackedScene = load(path)
	progess_bar.set_value.call_deferred(50.0)
	scene = packed.instantiate()
	progess_bar.set_value.call_deferred(75.0)
	_finished.call_deferred()
	
var task_id := 0
@onready var root : Window = get_tree().root
var scene : Node
func _finished() -> void:
	WorkerThreadPool.wait_for_task_completion(task_id)
	root.add_child(scene)
	hide()
