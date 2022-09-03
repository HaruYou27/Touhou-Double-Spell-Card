extends Node
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
onready var death_overlay :ColorRect = $Playground/Death

onready var playground :Control = $Playground
onready var ray :RayCast2D = $Playground/RayCast2D

onready var score_label :Label = $hud/VBoxContainer/Score
onready var graze_label :Label = $hud/VBoxContainer/Graze
onready var point_label :Label = $hud/VBoxContainer/Point
onready var bomb_label :Label = $hud/VBoxContainer/Bomb
onready var goal_label :Label = $hud/VBoxContainer/Goal

func _physics_process(_delta) -> void:
	if ray.is_colliding():
		ItemManager.autoCollect = true
		
func _process(_delta) -> void:
	if shake_frames:
		shake_frames -= 1
		playground.rect_position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))
	else:
		playground.rect_position = Vector2(60, 28)
		set_process(false)

func _ready() -> void:
	Global.connect("collect", self, "_update_point")
	Global.connect('graze', self, '_update_graze')
	Global.connect('bomb', self, '_update_bomb')
	Global.connect('shake', self, 'shake')
	if Global.save.hi_score.has(stage_name):
		var hi_score :Label = $hud/VBoxContainer/HiScore
		hi_score.text = hi_score.text % Global.save.hi_score[stage_name]
		Global.save.retry_count[stage_name] += 1
	else:
		Global.save.hi_score[stage_name] = 0
		Global.save.retry_count[stage_name] = 1
	
	level = get_node(level)
	bomb_label.text = bomb_label.text % Global.save.init_bomb
	set_process(false)
	playground.remove_child(death_overlay)
	VisualServer.canvas_item_set_z_index(death_overlay.get_canvas_item(), 4000)

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
	playground.add_child(level)
