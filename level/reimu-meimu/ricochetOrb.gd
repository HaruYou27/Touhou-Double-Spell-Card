extends ColorRect

onready var meimu := $Path2D/PathFollow2D
onready var barrel :Node2D = $meimu/bullet/Position2D
onready var tween := create_tween()

var age :float

func _ready():
	randomize()
	barrel.rotation = rand_range(0.0, 6.28)
	tween.tween_property(meimu, 'unit_offset', 1.0, 7)
	tween.set_loops()
	
func _physics_process(delta):
	barrel.rotation += 0.897 * delta
