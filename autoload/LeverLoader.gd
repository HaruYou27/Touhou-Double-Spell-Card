extends Control

var scene: Control
## Thread id. Collect with WorkerThreadPoll.
var tasks: PackedInt64Array = PackedInt64Array()
## Non-blocking level loader.
func load_scene(path:String, player:=false) -> void:
	tasks.append(WorkerThreadPool.add_task(instance_scene.bind(path)))
	if player:
		tasks.append(WorkerThreadPool.add_task(load_player.bind(player1, id1)))
		if id2 > 0:
			tasks.append(WorkerThreadPool.add_task(load_player.bind(player2, id2)))
		
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
var animating := false
## Should be call deferered.
func increase_bar() -> void:
	var percentage := 0
	if player1.is_empty() and player2.is_empty():
		percentage = 50
	else:
		percentage = 25
	progress_value += percentage
	
	if animating:
		return
	animating = true
	animate_bar.call_deferred()
	
var tween: Tween
func animate_bar() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(progess_bar, "value", progress_value, 1.0)
	animating = false

## Cache scene.
var scene_packed : PackedScene
## Should be called in a thread.
func instance_scene(path:String) -> void:
	if not path.is_empty():
		scene_packed = load(path)
	ItemManager.restart()
	increase_bar()
	scene = scene_packed.instantiate()
	increase_bar()
	
	finished.call_deferred()

## Cache player scene.
var player1_node: Node
## Cache player scene.
var player2_node: Node
## Should be called in a thread.
func load_player(path:String, id:int) -> void:
	var packed: PackedScene
	if path.is_empty():
		if id == id1:
			packed = player1_packed
		else:
			packed = player2_packed
	else:
		packed = load(path)
	var player: Node = packed.instantiate()
	player.name = str(id)
	player.set_multiplayer_authority(id)
	
	if id == id1:
		player1_packed = packed
		player2 = ''
		player1_node = player
	else:
		player2 = ''
		player2_packed = packed
		player2_node = player
	
	increase_bar()
	finished.call_deferred()
	
@onready var root : Window = get_tree().root
## Called everytime a thread is done. But only collect when all threads are done.
func finished() -> void:
	if tasks.is_empty():
		# What
		return
	for task in tasks:
		if not WorkerThreadPool.is_task_completed(task):
			return
	for task in tasks:
		WorkerThreadPool.wait_for_task_completion(task)
	tasks.clear()
	
	if player1_node:
		scene.add_child(player1_node)
		player1_node = null
	if player2_node:
		scene.add_child(player2_node)
		player2_node = null
	root.add_child(scene)
	
	progress_value = 0
	hide()

@onready var shake_intensity := Global.user_data.screen_shake_intensity
@export var noise: FastNoiseLite
var shake_duration := 0.0
func _process(delta: float) -> void:
	scene.position.x += noise.get_noise_2d(-Time.get_ticks_msec(), -Time.get_ticks_msec()) * shake_intensity
	scene.position.y += noise.get_noise_2d(Time.get_ticks_msec(), Time.get_ticks_msec()) * shake_intensity
	scene.position = scene.position.clampf(-5.0, 5.0)
	scene.rotation_degrees += noise.get_noise_1d(Time.get_ticks_msec())
	scene.rotation_degrees = clampf(scene.rotation_degrees, -0.25, 0.25)
	
	shake_duration -= delta
	if shake_duration < 0.0:
		shake_duration = 0.0
		set_process(false)
		scene.position = Vector2.ZERO
		scene.rotation_degrees = 0.0

func screen_shake(duration:float) -> void:
	set_process(true)
	shake_duration += duration

func _peer_disconnected() -> void:
	id2 = 0

func _ready() -> void:
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	set_process(false)
