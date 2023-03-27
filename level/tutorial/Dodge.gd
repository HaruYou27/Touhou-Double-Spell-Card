extends Node2D

var harder := false

@onready var bullet := $bullet
@onready var bullet2 := $bullet2
@onready var timer :Timer = $Timer2

func _ready() -> void:
	set_physics_process(false)
	
func start_event() -> void:
	$Timer.start()
	timer.start()
	set_physics_process(true)
	Global.bomb_impact.connect(Callable(self, 'queue_free'))
	
func _physics_process(delta:float) -> void:
	bullet.rotation += delta * TAU
	bullet2.rotation -= delta * TAU

func _on_timer_timeout() -> void:
	if not harder:
		bullet.speed = 372
		bullet2.speed = bullet.speed
		timer.wait_time = 0.01
		harder = true
	else:
		bullet.speed = 572
		bullet2.speed = bullet.speed
		
		bullet.dynamicBarrel = true
		bullet2.dynamicBarrel = true
		var nodes := bullet2.get_children()
		for node in bullet.get_children():
			bullet2.add_child(node.duplicate())
		for node in nodes:
			bullet.add_child(node.duplicate())
