extends Control

var scene: Control
## Thread id. Collect with WorkerThreadPoll.
var task := 0
## Non-blocking level loader.
func load_scene(path:String, player:=false) -> void:
	ScreenEffect.hide()
	task = WorkerThreadPool.add_task(instance_scene.bind(path, player))
	
	scene.queue_free()
	progess_bar.value = 0.0
	show()

@onready var progess_bar: ProgressBar = $VBoxContainer/ProgressBar
var player1 := ''
var player1_packed : PackedScene
var id1 := 1
var player2 := ''
var player2_packed : PackedScene
var id2 := 0
@rpc("reliable", "any_peer", "call_remote")
func _set_player2_character(path:String) -> void:
	player2 = path
	id2 = multiplayer.get_remote_sender_id()
	id1 = multiplayer.get_unique_id()

var progress_value := 0
var tween: Tween
## Animate the progress bar.
func increase_bar() -> void:
	var percentage := 0
	if player1.is_empty() and player2.is_empty():
		percentage = 50
	else:
		percentage = 25
	progress_value += percentage
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(progess_bar, "value", progress_value, 0.5)

## Cache scene.
var scene_packed : PackedScene
## Should be called in a thread. Use cache if path is empty.
func instance_scene(path:String, player:bool) -> void:
	if not path.is_empty():
		scene_packed = load(path)
	GlobalBullet.call_deferred("Clear")
	increase_bar.call_deferred()
	scene = scene_packed.instantiate()
	increase_bar.call_deferred()
	
	if player:
		if not player1.is_empty():
			player1_packed = load(player1)
			player1 = ""
			
		scene.add_child(load_player(player1_packed, id1))
		if id2 > 0:
			if not player2.is_empty():
				player2_packed = load(player1)
				player2 = ""
			scene.add_child(load_player(player2_packed, id2))
	
	finished.call_deferred()

## Load player scene, use cache if path is empty.
func load_player(packed:PackedScene, id:int) -> Node:
	var player: Node = packed.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	
	increase_bar.call_deferred()
	return player
	
@onready var root : Window = get_tree().root
## Collect thread.
func finished() -> void:
	WorkerThreadPool.wait_for_task_completion(task)
	root.add_child(scene)
	
	progress_value = 0
	hide()

func _peer_disconnected() -> void:
	id2 = 0

func _ready() -> void:
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	set_process(false)
	hide()
