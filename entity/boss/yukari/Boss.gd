extends Area2D
class_name Boss

@export var bonus_threshold := 3272
@export var heath_bar: Range
## Avoid reimu bomb bug.
const hp := 1

func hit() -> void:
	heath_bar.value += 1

func _on_body_entered(body:Node2D) -> void:
	if body is not Player or not body.is_multiplayer_authority():
		return
	body.hit()

func _ready() -> void:
	set_process(false)
	heath_bar.max_value = bonus_threshold

var item_count := 0
func _process(_delta: float) -> void:
	if item_count < 0:
		set_process(false)
		return
	
	if item_count > 27:
		item_count -= 27
		GlobalBullet.call_deferred("SpawnItems", 27, global_position)
		return
	
	GlobalBullet.call_deferred("SpawnItems", item_count, global_position)
	item_count = 0
	
var tween
func spawn_item():
	set_process(true)
	item_count = heath_bar.value
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(heath_bar, "value", 0, 1.0)
