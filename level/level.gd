extends Control
class_name Level

var shaking := 0.0

export (Array) var levels : Array
export (NodePath) var level
export (String) var stage_name

onready var tree = get_tree()
onready var overlay := ColorRect.new()
onready var item_get_border :RayCast2D = $RayCast2D
onready var hud :Sprite = $hud

func _ready() -> void:
	Rewind.timer.start()
	ItemManager.Flush()
	BulletFx.index = 0
	
	Global.connect("impact", self, 'impact')
	Global.player.connect('die', self, 'flash_red')
	Global.connect("bomb", self, 'bomb')
	
	VisualServer.canvas_item_set_z_index(overlay.get_canvas_item(), 4000)
	var tween := fade2black()
	tween.connect("finished", overlay, 'set_size', [rect_size])
	tween.connect("finished", hud, 'remove_child', [overlay])
	
	level = get_node(level)
	
func _exit_tree() -> void:
	Global.save_data.level = tree.current_scene

func _physics_process(_delta) -> void:
	if item_get_border.is_colliding():
		ItemManager.autoCollect = true
		
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
	level.queue_free()
	level = levels.pop_back().instance()
	add_child(level)

func _on_Quit_pressed():
	var tween := fade2black()
	tween.connect("finished", tree, 'change_scene', ["res://user-interface/mainMenu/Menu.scn"])
