extends Node

@onready var tree := get_tree()
@onready var parent :Node2D = get_parent()
@onready var rotator := $rotator
@onready var orbs := rotator.get_children()
@onready var explosion := $explosion

const velocity := Vector2(127, 0)
@onready var explode_spot := Global.leveler.to_global(Vector2(307, 222))

func _ready():
	set_physics_process(false)
	explosion.global_position = explode_spot
	
	var timer := tree.create_timer(1.0)
	timer.connect("timeout",Callable(self,'set_physics_process').bind(true))
	timer.connect("timeout",Callable(self,'set_process').bind(false))
	
func _process(delta):
	rotator.global_position = parent.global_position
	rotator.rotation += delta * TAU
	
	var offset :Vector2 = velocity * delta
	for orb in orbs:
		orb.transform = orb.transform.translated(offset)
	
func _physics_process(delta):
	var speed :float = 727 * delta
	for orb in orbs:
		var direction :Vector2 = explode_spot - orb.global_position
		if direction.length() < 55:
			Global.emit_signal("bomb_impact")
			explosion.emitting = true
			set_physics_process(false)
			var timer := tree.create_timer(2.0)
			timer.connect("timeout",Callable(self,'queue_free'))
			return
			
		orb.global_position += direction.normalized() * speed
