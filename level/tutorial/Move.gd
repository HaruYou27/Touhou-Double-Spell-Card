extends Label

signal next_event

@onready var init_pos : Vector2
@onready var timer : Timer = $Timer

var player : Player

func _ready() -> void:
	set_physics_process(false)
	
func start_event() -> void:
	timer.start()
	player = Global.player
	init_pos = player.global_position
	set_physics_process(true)

func _physics_process(_delta) -> void:
	if player.global_position != init_pos:
		timer.stop()
		next_event.emit()
		queue_free()
