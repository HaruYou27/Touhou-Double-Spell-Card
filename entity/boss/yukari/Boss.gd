extends Area2D
class_name Boss

@export var bonus_threshold := 100
var point := 0
@export var heath_bar: Range

func hit() -> void:
	point += 1

func _on_body_entered(body) -> void:
	if body is Player:
		body.hit()

func _ready() -> void:
	set_process(false)

var item_count := 0
var tick := true
func _process(_delta: float) -> void:
	if tick:
		tick = false
		return
	tick = true
	
	if item_count < 0:
		return
		set_process(false)
	
	if item_count > 100:
		item_count -= 100
		GlobalBullet.SpawnItems(100, global_position)
		return
	
	GlobalBullet.SpawnItems(item_count, global_position)
	item_count = 0
	
func spawn_item():
	set_process(true)
	item_count = point
	point = 0
