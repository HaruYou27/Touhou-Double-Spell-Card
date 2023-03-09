extends Timer

@onready var init_pos :Vector2
var player

func _ready() -> void:
	set_physics_process(false)
	Global.can_shoot = false
	
func start_level() -> void:
	start()
	player = Global.player
	init_pos = player.global_position
	set_physics_process(true)

func _physics_process(_delta) -> void:
	if player.global_position != init_pos:
		Global.leveler.next_level()
		stop()

func _on_timeout() -> void:
	add_child(Dialogic.start('/tutorial/move'))
