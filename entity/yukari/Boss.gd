extends Area2D
class_name Boss

signal start_event
signal next_event

var point := 0

func _ready() -> void:
	Global.boss = self

@export var hp_bar : TextureProgressBar
@export var time_bar : TextureProgressBar
func setup(timer:float, p:int, hp:=0) -> void:
	monitorable = false
	point = p
	
	var tween := create_tween()
	time_bar.value = 0.
	time_bar.max_value = timer
	tween.tween_property(time_bar, 'value', timer, 1.)
	tween.finished.connect(_setup_finished)
	
	hp_bar.value = 0.
	if hp:
		hp_bar.max_value = hp
		tween.parallel().tween_property(hp_bar, 'value', hp, 1.)
		time_bar.radial_fill_degrees = 180.
	else:
		time_bar.radial_fill_degrees = 360.
	
func _setup_finished() -> void:
	if hp_bar.value:
		monitorable = true
	var tween := create_tween()
	tween.tween_property(time_bar, 'value', 0., time_bar.value)
	
	start_event.emit()

func _timeout() -> void:
	if not point or hp_bar.value:
		return
	else:
		#ItemManager.SpawnItem(point, global_position)
		next_event.emit()

@rpc("any_peer")
func _hit() -> void:
	hp_bar.value -= 1
	rpc('_hit')
	if not hp_bar.value:
		#ItemManager.SpawnItem(point * time_bar.value / time_bar.max_value)
		next_event.emit()

func _on_body_entered(body):
	if body is Player:
		body._hit()
	elif hp_bar.value:
		hp_bar.value -= hp_bar.max_value / 2
		point = 0
		_hit()
