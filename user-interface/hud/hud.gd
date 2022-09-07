extends Control
class_name Stage

var point := 1
var graze := 0
var goal := 0
var saved := false
var shake_frames := 0

export (Array) var levels : Array
export (NodePath) var level
export (String) var stage_name

onready var tree = get_tree()
onready var screenFx :ColorRect = $Playground/screenFx
onready var tween := create_tween()
onready var ray :RayCast2D = $Playground/RayCast2D

onready var score_label :Label = $background/VBoxContainer/Score
onready var graze_label :Label = $background/VBoxContainer/Graze
onready var point_label :Label = $background/VBoxContainer/Point
onready var bomb_label :Label = $background/VBoxContainer/Bomb
onready var goal_label :Label = $background/VBoxContainer/Goal

func _physics_process(_delta) -> void:
	if ray.is_colliding():
		ItemManager.autoCollect = true
		
func _process(_delta) -> void:
	if shake_frames:
		shake_frames -= 1
		rect_position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
	else:
		rect_position = Vector2(60, 28)
		set_process(false)

func _ready() -> void:
	Global.connect("collect", self, "_update_point")
	Global.connect('graze', self, '_update_graze')
	Global.connect('bomb', self, '_update_bomb')
	Global.connect('shake', self, 'shake')
	
	if Global.save.hi_score.has(stage_name):
		var hi_score :Label = $background/VBoxContainer/HiScore
		hi_score.text = hi_score.text % Global.save.hi_score[stage_name]
		Global.save.retry_count[stage_name] += 1
	else:
		Global.save.hi_score[stage_name] = 0
		Global.save.retry_count[stage_name] = 1
	
	level = get_node(level)
	bomb_label.text = bomb_label.text % Global.save.init_bomb
	set_process(false)
	remove_child(screenFx)
	VisualServer.canvas_item_set_z_index(screenFx.get_canvas_item(), 4000)
	
func flash() -> void:
	screenFx.color = Color(1, 1, 1, .75)
	tween.kill()
	tween = create_tween()
	tween.tween_property(screenFx, 'color', Color(1, 1, 1, 0), .15)

func shake(duration:int) -> void:
	shake_frames += duration
	set_process(true)

func _update_point() -> void:
	point += 1
	point_label.text = 'Point:                         %06d' % point
	_update_score(point * graze)
	
func _update_graze() -> void:
	graze += 1
	graze_label.text = 'Graze:                       %06d' % graze
	_update_score(graze * point)
	
func _update_score(score:int) -> void:
	score_label.text = 'Score:                %010d' % score
	var score_left = goal - score
	if score_left < INF:
		goal_label.text = 'Next:                      %010d' % score_left
	else:
		Global.player.bomb += 1
		_update_bomb()

func _update_bomb() -> void:
	bomb_label.text = 'Bomb:        %d' % Global.player.bombs
	
func save_score() -> void:
	var score = point * graze
	if Global.save.hi_score[stage_name] < score and not saved:
		Global.save.hi_score[stage_name] = score
		Global.save.save()
		saved = true

func _next() -> void:
	level.queue_free()
	level = levels.pop_back().instance()
	add_child(level)
