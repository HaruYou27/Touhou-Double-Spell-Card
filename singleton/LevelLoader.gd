extends Control

var scene: Control
## Thread id. Collect with WorkerThreadPoll.
var task := 0
@onready var viewport := get_viewport()
@onready var background: Sprite2D = $background
## Non-blocking level loader.
func load_scene(path:String, player:=false) -> void:
	background.texture = ImageTexture.create_from_image(viewport.get_texture().get_image())
	ScreenVFX.hide()
	scene.queue_free()
	task = WorkerThreadPool.add_task(_instance_scene.bind(path, player))
	
	progess_bar.value = 0.0
	increase_bar(75.0)
	show()

@onready var progess_bar: ProgressBar = $VBoxContainer/ProgressBar
var player1 := ''
var player1_packed : PackedScene
var id1 := 1

var progress_value := 0.0
var tween: Tween
## Animate the progress bar.
func increase_bar(percentage:float) -> void:
	progress_value += percentage
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(progess_bar, "value", progress_value, 1.0)

## Cache scene.
var scene_packed : PackedScene
## Should be called in a thread. Use cache if path is empty.
func _instance_scene(path:String, player:bool) -> void:
	if not path.is_empty():
		scene_packed = load(path)
	increase_bar.call_deferred(25.0)
	
	GlobalItem.call_deferred("clear")
	ScreenVFX.call_deferred("reset")
	scene = scene_packed.instantiate()

	if player:
		if not player1.is_empty():
			player1_packed = load(player1)
			player1 = ""
			
		scene.add_child(load_player(player1_packed, id1))
	
	finished.call_deferred()

## Load player scene, use cache if path is empty.
func load_player(packed:PackedScene, id:int) -> Node:
	var player: Node = packed.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)

	return player
	
@onready var root : Window = get_tree().root
## Collect thread.
func finished() -> void:
	WorkerThreadPool.wait_for_task_completion(task)
	root.add_child(scene)
	
	progress_value = 0
	hide()

func _ready() -> void:
	set_process(false)
	hide()

var task_config := 0
##Save user config.
func save_config() -> void:
	task_config = WorkerThreadPool.add_task(_save_config)

func _save_config() -> void:
	if Engine.is_editor_hint:
		return
	ProjectSettings.save_custom('user://override.cfg')
	ResourceSaver.save(Global.user_data, Global.config_path, ResourceSaver.FLAG_COMPRESS)
	_collect_task_config.call_deferred()
	
func _collect_task_config() -> void:
	WorkerThreadPool.wait_for_task_completion(task_config)
