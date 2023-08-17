extends Control

func load_scene(path:String) -> void:
	progess_bar.value = 0.0
	show()
	scene.queue_free()
	task_id = WorkerThreadPool.add_task(_instance_scene.bind(path))

@onready var progess_bar := $ProgressBar
var player1 := ''
var player1_packed : PackedScene
var id1 := 1
var player2 := ''
var player2_packed : PackedScene
var id2 := 0
@rpc("reliable", "any_peer")
func _set_player2_character(path:String) -> void:
	player2 = path
	id2 = multiplayer.get_remote_sender_id()
	id1 = multiplayer.get_unique_id()

var packed : PackedScene
func _instance_scene(path:String) -> void:
	packed = load(path)
	ItemManager.restart()
	progess_bar.set_value.call_deferred(25.0)
	scene = packed.instantiate()
	progess_bar.set_value.call_deferred(50.0)
	
	if not player2.is_empty():
		player2_packed = load(player2)
		var player : Node = player2_packed.instantiate()
		player.name = str(id2)
		player.set_multiplayer_authority(id2)
		scene.add_child(player)
		progess_bar.set_value.call_deferred(75.0)
		player2 = ''
		
	if not player1.is_empty():
		player1_packed = load(player1)
		var player : Node = player1_packed.instantiate()
		player.name = str(id1)
		scene.add_child(player)
		player1 = ''
	progess_bar.set_value.call_deferred(100.0)
	
	_finished.call_deferred()
	
var task_id := 0
@onready var root : Window = get_tree().root
var scene : Node
func _finished() -> void:
	WorkerThreadPool.wait_for_task_completion(task_id)
	root.add_child(scene)
	hide()

func restart_level() -> void:
	ItemManager.restart()
	root.remove_child(scene)
	scene.queue_free()
	scene = packed.instantiate()
	
	var player = player1_packed.instantiate()
	player.name = str(id1)
	scene.add_child(player)
	
	if player2_packed:
		player = player2_packed.instantiate()
		player.name = str(id2)
		player.set_multiplayer_authority(id2)
		scene.add_child(player)
	
	root.add_child(scene)
