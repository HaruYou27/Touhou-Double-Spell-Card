extends Node2D

@export var timer1 : Timer
@export var timer2 : Timer
@export var orb1 : Node2D
@export var orb2 : Node2D

@export var orb_animator : AnimationPlayer

func _ready() -> void:
	orb_animator.play("spin")
	Global.can_player_shoot.connect(_set_shooting)
	
func _set_shooting(value:bool) -> void:
	if value:
		timer1.start()
		timer2.start()
		orb_animator.speed_scale = 1.25
		orb1.modulate = Color.WHITE
		orb2.modulate = orb1.modulate
	else:
		timer1.stop()
		timer2.stop()
		orb_animator.speed_scale = .25
		orb1.modulate = Color(0.5686274766922, 0.5686274766922, 0.5686274766922, 0.83529412746429)
		orb2.modulate = orb1.modulate
