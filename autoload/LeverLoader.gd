extends Control

func _ready() -> void:
	set_process(false)

var resource_path : String
func load_scene(path:String) -> void:
	show()
	resource_path = path
	ResourceLoader.load_threaded_request(path, "PackedScene", true)
	set_process(true)
	progess_bar.value = 0
	
var tree := get_tree()
@onready var progess_bar := $ProgressBar
var percentage := []
var tick := true
func _process(_delta) -> void:
	tick = not tick
	if tick:
		return
	
	if ResourceLoader.load_threaded_get_status(resource_path, percentage):
		tree.change_scene_to_packed(ResourceLoader.load_threaded_get(resource_path))
		hide()
	else:
		progess_bar.value = percentage.back()
