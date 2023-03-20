extends Label

@onready var init_pos : Vector2
@onready var timer : Timer = $Timer

var player

func _ready() -> void:
	set_physics_process(false)
	Global.can_shoot = false
	
func start_level() -> void:
	timer.start()
	player = Global.player
	init_pos = player.global_position
	set_physics_process(true)

func _physics_process(_delta) -> void:
	if player.global_position != init_pos:
		Global.leveler.next_event()
		timer.stop()
