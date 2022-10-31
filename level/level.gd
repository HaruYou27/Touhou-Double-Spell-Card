extends Control
class_name Level

var shaking := 0.0

export (Array) var levels : Array
export (NodePath) var level
export (PackedScene) var dialogue
export (int, 0, 7) var stage

onready var tree = get_tree()
onready var overlay := ColorRect.new()
onready var item_get_border :Area2D = $itemGet
onready var hud :Sprite = $hud
onready var save : CharacterData

func _ready() -> void:
	Rewind.set_process(true)
	ItemManager.Flush()
	BulletFx.index = 0
	
	Global.connect("impact", self, 'impact')
	Global.player.connect('die', self, 'flash_red')
	Global.connect("bomb", self, 'bomb')
	Global.connect("next_level", self, 'next')
	Global.save_data.last_level = tree.current_scene.filename
	
	VisualServer.canvas_item_set_z_index(overlay.get_canvas_item(), 4000)
	var tween := fade2black()
	tween.connect("finished", overlay, 'set_size', [rect_size])
	tween.connect("finished", hud, 'remove_child', [overlay])
	
	save = Global.get_char_data()
	$hud/VBoxContainer/HiScore.update_label(save.score[stage])
	save.retry_count[stage] += 1
	Global.save_data.save()
	
	level = get_node(level)
	
func _process(delta) -> void:
	if shaking <= 0.0:
		rect_position = Vector2(60, 28)
		set_process(false)
	else:
		shaking -= delta
		rect_position += Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0))

func fade2black() -> SceneTreeTween:
	overlay.rect_size = Global.game_rect
	overlay.color = Global.fade_black
	var tween := create_tween()
	tween.tween_property(overlay, 'color', Global.fade_trans, Global.fade_time)
	return tween

func flash_red() -> void:
	if tree.paused:
		return
		
	add_child(overlay)
	overlay.color = Color(0.996078, 0.203922, 0.203922, 0.592157)
	
func bomb() -> void:
	remove_child(overlay)

func impact() -> void:
	shaking += .15
	set_process(true)
	
	add_child(overlay)
	overlay.color = Color(1, 1, 1, .5)
	var tween := create_tween()
	tween.tween_property(overlay, 'color', Color.transparent, .15)
	tween.connect("finished", self, 'remove_child', [overlay])

func next() -> void:
	if levels.size():
		level.queue_free()
		level = levels.pop_back().instance()
		add_child(level)
		return
	
	var score :int = hud.point * hud.graze
	if score > save.score[stage]:
		save.score[stage] = score
		Global.save_data.save()

func _on_Quit_pressed():
	var tween := fade2black()
	tween.connect("finished", tree, 'change_scene', ["res://user-interface/mainMenu/Menu.scn"])

func _on_itemGet_body_entered(_body):
	ItemManager.autoCollect = true
	ItemManager.keepCollect = true

func _on_itemGet_body_exited(body):
	ItemManager.keepCollect = false
	
