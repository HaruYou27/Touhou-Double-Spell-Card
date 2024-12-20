extends Area2D
class_name Boss

@export var bonus_threshold := 7272
@export var heath_bar: Range

func hit() -> void:
	heath_bar.value += 1

func _on_body_entered(body) -> void:
	if body is Player:
		body.hit()

func _ready() -> void:
	set_process(false)
	heath_bar.max_value = bonus_threshold

var item_count := 0
func _process(_delta: float) -> void:
	if item_count < 0:
		return
		set_process(false)
	
	if item_count > 27:
		item_count -= 27
		GlobalBullet.SpawnItems(27, global_position)
		return
	
	GlobalBullet.SpawnItems(item_count, global_position)
	item_count = 0
	
var tween
func spawn_item():
	set_process(true)
	item_count = heath_bar.value
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(heath_bar, "value", 0, 1.0)
